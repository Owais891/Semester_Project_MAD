import 'package:crust_food/core/auth/auth_session.dart';
import 'package:crust_food/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomePage layout does not overflow in a narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(tester.takeException(), isNull);
  });

  testWidgets('Home menu stays compact at tablet width', (tester) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(tester.takeException(), isNull);
  });

  testWidgets('Item options arrow opens quantity controls', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    final optionsButton = find.byTooltip('Item options').first;
    await tester.ensureVisible(optionsButton);
    await tester.pumpAndSettle();
    await tester.tap(optionsButton);
    await tester.pumpAndSettle();

    expect(find.text('Quantity'), findsOneWidget);
    expect(find.text('Add to cart'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Customer can checkout and see the placed order', (tester) async {
    final session = AuthSession.instance;
    session.signOut();
    if (!session.signInCustomer('checkout-test@example.com', 'secret123')) {
      expect(
        session.registerCustomer('checkout-test@example.com', 'secret123'),
        isTrue,
      );
    }
    addTearDown(session.signOut);

    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    final firstAddButton = find.byIcon(Icons.add).first;
    await tester.ensureVisible(firstAddButton);
    await tester.pumpAndSettle();
    await tester.tap(firstAddButton);
    await tester.pump();
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart'), findsOneWidget);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Ayesha Khan');
    await tester.enterText(find.byType(TextFormField).at(1), '03001234567');
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'House 12, Street 4, Islamabad',
    );
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();

    expect(find.text('Your orders'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Customer can edit profile and add a saved address', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.tap(find.text('Profile').first);
    await tester.pumpAndSettle();
    expect(find.text('Ayesha Khan'), findsOneWidget);
    expect(find.text('Personal information'), findsOneWidget);

    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Mina Ali');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Mina Ali'), findsOneWidget);

    await tester.tap(find.text('Saved addresses'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add address'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Work');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Office 8, Blue Area, Islamabad',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Office 8, Blue Area, Islamabad'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
