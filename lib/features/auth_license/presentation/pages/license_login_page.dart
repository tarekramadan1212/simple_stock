import 'package:flutter/material.dart';

class LicenseLoginPage extends StatelessWidget {
  const LicenseLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Login'),
      ),
      body: const Center(
        child: Text('License Login Page'),
      ),
    );
  }
}
