import 'package:crust_food/app/crust_app.dart';
import 'package:crust_food/core/auth/auth_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('customer must sign in or sign up before placing an order', (
    tester,
  ) async {
    final session = AuthSession.instance;
    final email =
        'checkout-${DateTime.now().microsecondsSinceEpoch}'
        '@example.com';
    session.signOut();
    addTearDown(session.signOut);

    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: CrustApp()));
    await tester.pumpAndSettle();

    final addButton = find.byIcon(Icons.add).first;
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Delivery details'), findsNothing);
    expect(session.role, isNull);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email address'),
      email,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'wrongpass',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(
      find.text('Email or password is incorrect. Create an account first.'),
      findsOneWidget,
    );
    expect(find.text('Delivery details'), findsNothing);
    expect(session.role, isNull);

    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();
    expect(find.text('Create your account'), findsOneWidget);

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name'), findsOneWidget);
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Ayesha Khan',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email address'),
      email,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'short',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm password'),
      'different',
    );
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(find.text('Delivery details'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm password'),
      'secret123',
    );
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(session.role, AccountRole.customer);
    expect(session.email, email);
    expect(find.text('Create your account'), findsNothing);
    expect(find.text('Welcome back'), findsNothing);
    expect(find.text('Your cart'), findsOneWidget);
    expect(find.text('Delivery details'), findsNothing);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Delivery details'), findsOneWidget);

    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name'), findsOneWidget);
    expect(find.text('Enter a valid phone number'), findsOneWidget);
    expect(find.text('Enter a full delivery address'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Ayesha Khan',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone number'),
      '03001234567',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Delivery address'),
      'House 12, Street 4, Islamabad',
    );
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();

    expect(find.text('Your orders'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('existing customer can sign in before checkout', (tester) async {
    final session = AuthSession.instance;
    final email = 'login-${DateTime.now().microsecondsSinceEpoch}@example.com';
    const password = 'secret123';
    session.signOut();
    expect(session.registerCustomer(email, password), isTrue);
    session.signOut();
    addTearDown(session.signOut);

    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: CrustApp()));
    await tester.pumpAndSettle();

    final addButton = find.byIcon(Icons.add).first;
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email address'),
      email,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      password,
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(session.role, AccountRole.customer);
    expect(session.email, email);
    expect(find.text('Welcome back'), findsNothing);
    expect(find.text('Your cart'), findsOneWidget);
    expect(find.text('Delivery details'), findsNothing);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Delivery details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
