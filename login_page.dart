import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/routing/app_router.dart';
import 'auth_page_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _signInError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    if (!AuthSession.instance.signInCustomer(email, _passwordController.text)) {
      setState(
        () => _signInError =
            'Email or password is incorrect. Create an account first.',
      );
      return;
    }
    Navigator.of(context).pop(email);
  }

  Future<void> _openSignUp() async {
    final email = await context.push<String>(AppRoutes.signUp);
    if (email != null && mounted) Navigator.of(context).pop(email);
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      title: 'Welcome back',
      subtitle: 'Sign in to keep your Crust Food orders close at hand.',
      footnote: 'Demo sign-in validates your details on this device. Online authentication is not connected.',
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
                    ? null
                    : 'Enter a valid email address';
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _signIn(),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) => (value?.length ?? 0) >= 6
                  ? null
                  : 'Password must be at least 6 characters',
            ),
            if (_signInError != null) ...[
              const SizedBox(height: 12),
              Text(
                _signInError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: _signIn, child: const Text('Sign in')),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _openSignUp,
              child: const Text('Create an account'),
            ),
            TextButton(
              onPressed: () => context.push<void>(AppRoutes.adminLogin),
              child: const Text('Staff sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
