import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/auth_license/presentation/pages/license_login_page.dart';

void main() {
  runApp(const SimpleStockApp());
}

class SimpleStockApp extends StatelessWidget {
  const SimpleStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Stock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
      ),
      home: const LicenseLoginPage(),
    );
  }
}
