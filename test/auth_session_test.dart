import 'package:crust_food/core/auth/auth_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthSession', () {
    test('customer registration and sign-in activate the customer role', () {
      final session = AuthSession();
      addTearDown(session.dispose);

      expect(session.registerCustomer('user@example.com', 'secret123'), isTrue);
      expect(session.role, AccountRole.customer);
      expect(session.email, 'user@example.com');

      session.signOut();
      expect(session.signInCustomer('USER@example.com', 'secret123'), isTrue);
      expect(session.role, AccountRole.customer);
    });

    test('admin credentials cannot register or sign in as a customer', () {
      final session = AuthSession();
      addTearDown(session.dispose);

      expect(
        session.registerCustomer(
          AuthSession.demoAdminEmail,
          AuthSession.demoAdminPassword,
        ),
        isFalse,
      );
      expect(
        session.signInCustomer(
          AuthSession.demoAdminEmail,
          AuthSession.demoAdminPassword,
        ),
        isFalse,
      );
    });

    test('only the configured admin credentials activate the admin role', () {
      final session = AuthSession();
      addTearDown(session.dispose);

      expect(session.signInAdmin('admin@crustfood.com', 'incorrect'), isFalse);
      expect(session.isAdmin, isFalse);
      expect(
        session.signInAdmin(
          AuthSession.demoAdminEmail,
          AuthSession.demoAdminPassword,
        ),
        isTrue,
      );
      expect(session.role, AccountRole.admin);
      expect(session.isAdmin, isTrue);
    });

    test(
      'customer sign-in rejects unknown accounts and incorrect passwords',
      () {
        final session = AuthSession();
        addTearDown(session.dispose);

        expect(
          session.signInCustomer('unknown@example.com', 'secret123'),
          isFalse,
        );
        session.registerCustomer('user@example.com', 'secret123');
        session.signOut();
        expect(
          session.signInCustomer('user@example.com', 'wrongpass'),
          isFalse,
        );
        expect(session.role, isNull);
      },
    );
  });
}
