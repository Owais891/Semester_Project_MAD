import 'package:flutter/foundation.dart';

enum AccountRole { customer, admin }

class AuthSession extends ChangeNotifier {
  AuthSession();

  static final instance = AuthSession();
  static const demoAdminEmail = 'admin@crustfood.com';
  static const demoAdminPassword = 'admin123';

  final Map<String, String> _customerAccounts = <String, String>{};
  AccountRole? _role;
  String? _email;

  AccountRole? get role => _role;
  String? get email => _email;
  bool get isAdmin => _role == AccountRole.admin;

  bool registerCustomer(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail == demoAdminEmail ||
        _customerAccounts.containsKey(normalizedEmail)) {
      return false;
    }

    // Demo-only in-memory credentials; use a trusted auth provider in production.
    _customerAccounts[normalizedEmail] = password;
    _activate(AccountRole.customer, normalizedEmail);
    return true;
  }

  bool signInCustomer(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_customerAccounts[normalizedEmail] != password) return false;
    _activate(AccountRole.customer, normalizedEmail);
    return true;
  }

  bool signInAdmin(String email, String password) {
    if (email.trim().toLowerCase() != demoAdminEmail ||
        password != demoAdminPassword) {
      return false;
    }
    _activate(AccountRole.admin, demoAdminEmail);
    return true;
  }

  void signOut() {
    _role = null;
    _email = null;
    notifyListeners();
  }

  void _activate(AccountRole role, String email) {
    _role = role;
    _email = email;
    notifyListeners();
  }
}
