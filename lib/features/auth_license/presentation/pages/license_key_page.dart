import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';
import 'shop_setup_page.dart';

class LicenseKeyPage extends StatefulWidget {
  const LicenseKeyPage({super.key});

  @override
  State<LicenseKeyPage> createState() => _LicenseKeyPageState();
}

class _LicenseKeyPageState extends State<LicenseKeyPage> {
  final _formKey = GlobalKey<FormState>();
  final _licenseKeyController = TextEditingController();

  @override
  void dispose() {
    _licenseKeyController.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final key = _licenseKeyController.text.trim();
      context.read<AuthBloc>().add(ValidateLicenseSubmitted(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('License Activation'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LicenseUnusedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShopSetupPage(
                  licenseKey: state.licenseInfo.key,
                ),
              ),
            );
          } else if (state is LicenseUsedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'License is already registered. Redirecting to login...',
                ),
                backgroundColor: AppColors.primary,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
            );
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.key_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome to Simple Stock',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your license key to activate your shop or log in.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _licenseKeyController,
                        decoration: const InputDecoration(
                          labelText: 'License Key',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          hintText: 'e.g. LIC-12345678',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a valid license key';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ElevatedButton(
                            onPressed: _onVerifyPressed,
                            child: const Text('Verify License'),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Already have an account? Log In'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
