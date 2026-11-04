import 'package:flutter/material.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin sign in')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Staff access', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text('The protected staff sign-in flow has not been connected yet.'),
                const SizedBox(height: 24),
                const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'Work email', prefixIcon: Icon(Icons.email_outlined))),
                const SizedBox(height: 12),
                const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline))),
                const SizedBox(height: 20),
                FilledButton(onPressed: null, child: const Text('Sign in')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
