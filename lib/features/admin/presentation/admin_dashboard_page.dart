import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Staff tools will appear here when the admin feature is implemented.', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
