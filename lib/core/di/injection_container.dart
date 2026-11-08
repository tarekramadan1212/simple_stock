import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth_license/data/datasources/auth_remote_data_source.dart';
import '../../features/auth_license/data/repositories/auth_repository_impl.dart';
import '../../features/auth_license/domain/repositories/auth_repository.dart';
import '../../features/auth_license/domain/usecases/login_with_email_password.dart';
import '../../features/auth_license/domain/usecases/save_shop_profile.dart';
import '../../features/auth_license/domain/usecases/validate_license.dart';
import '../../features/auth_license/presentation/bloc/auth_bloc.dart';
import '../../features/inventory/presentation/bloc/inventory_cubit.dart';
import '../../features/invoicing/presentation/bloc/invoice_cubit.dart';
import '../../features/profile_reports/data/datasources/reports_remote_data_source.dart';
import '../../features/profile_reports/data/repositories/reports_repository_impl.dart';
import '../../features/profile_reports/domain/repositories/reports_repository.dart';
import '../../features/profile_reports/domain/usecases/get_purchase_summary.dart';
import '../../features/profile_reports/domain/usecases/get_sales_summary.dart';
import '../../features/profile_reports/domain/usecases/get_shop_profile.dart';
import '../../features/profile_reports/presentation/bloc/reports_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External (Firebase)
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton(() => FirebaseAuth.instance);
  }

  // Features - Auth / License
  // Bloc
  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory(
      () => AuthBloc(
        validateLicense: sl(),
        saveShopProfile: sl(),
        loginWithEmailPassword: sl(),
      ),
    );
  }

  // Use cases
  if (!sl.isRegistered<ValidateLicense>()) {
    sl.registerLazySingleton(() => ValidateLicense(sl()));
  }
  if (!sl.isRegistered<SaveShopProfile>()) {
    sl.registerLazySingleton(() => SaveShopProfile(sl()));
  }
  if (!sl.isRegistered<LoginWithEmailPassword>()) {
    sl.registerLazySingleton(() => LoginWithEmailPassword(sl()));
  }

  // Repository
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );
  }

  // Data sources
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firestore: sl(),
        firebaseAuth: sl(),
      ),
    );
  }

  // Features - Profile & Reports
  // Cubit
  if (!sl.isRegistered<ReportsCubit>()) {
    sl.registerFactory(
      () => ReportsCubit(
        getShopProfile: sl(),
        getSalesSummary: sl(),
        getPurchaseSummary: sl(),
      ),
    );
  }

  // Use cases
  if (!sl.isRegistered<GetShopProfile>()) {
    sl.registerLazySingleton(() => GetShopProfile(sl()));
  }
  if (!sl.isRegistered<GetSalesSummary>()) {
    sl.registerLazySingleton(() => GetSalesSummary(sl()));
  }
  if (!sl.isRegistered<GetPurchaseSummary>()) {
    sl.registerLazySingleton(() => GetPurchaseSummary(sl()));
  }

  // Repository
  if (!sl.isRegistered<ReportsRepository>()) {
    sl.registerLazySingleton<ReportsRepository>(
      () => ReportsRepositoryImpl(remoteDataSource: sl()),
    );
  }

  // Data sources
  if (!sl.isRegistered<ReportsRemoteDataSource>()) {
    sl.registerLazySingleton<ReportsRemoteDataSource>(
      () => ReportsRemoteDataSourceImpl(firestore: sl()),
    );
  }

  // Features - Inventory, Invoicing Cubits
  if (!sl.isRegistered<InventoryCubit>()) {
    sl.registerFactory(() => InventoryCubit());
  }
  if (!sl.isRegistered<InvoiceCubit>()) {
    sl.registerFactory(() => InvoiceCubit());
  }
}
