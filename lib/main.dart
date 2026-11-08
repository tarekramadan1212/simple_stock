import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/auth_license/presentation/bloc/auth_bloc.dart';
import 'features/auth_license/presentation/pages/license_key_page.dart';
import 'features/inventory/presentation/bloc/inventory_cubit.dart';
import 'features/invoicing/presentation/bloc/invoice_cubit.dart';
import 'features/profile_reports/presentation/bloc/reports_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();

  runApp(const SimpleStockApp());
}

class SimpleStockApp extends StatelessWidget {
  const SimpleStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<InventoryCubit>(
          create: (_) => di.sl<InventoryCubit>(),
        ),
        BlocProvider<InvoiceCubit>(
          create: (_) => di.sl<InvoiceCubit>(),
        ),
        BlocProvider<ReportsCubit>(
          create: (_) => di.sl<ReportsCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Simple Stock',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LicenseKeyPage(),
      ),
    );
  }
}
