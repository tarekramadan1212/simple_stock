import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth_license/data/datasources/auth_remote_data_source.dart';
import '../../features/auth_license/data/repositories/auth_repository_impl.dart';
import '../../features/auth_license/domain/repositories/auth_repository.dart';
import '../../features/auth_license/domain/usecases/save_shop_profile.dart';
import '../../features/auth_license/domain/usecases/validate_license.dart';
import '../../features/auth_license/presentation/bloc/auth_bloc.dart';
import '../../features/inventory/presentation/bloc/inventory_cubit.dart';
import '../../features/invoicing/presentation/bloc/invoice_cubit.dart';
import '../../features/profile_reports/presentation/bloc/reports_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth / License
  // Bloc
  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory(() => AuthBloc(validateLicense: sl()));
  }

  // Use cases
  if (!sl.isRegistered<ValidateLicense>()) {
    sl.registerLazySingleton(() => ValidateLicense(sl()));
  }
  if (!sl.isRegistered<SaveShopProfile>()) {
    sl.registerLazySingleton(() => SaveShopProfile(sl()));
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
      () => AuthRemoteDataSourceImpl(),
    );
  }

  // Features - Inventory, Invoicing, Profile Reports Cubits
  if (!sl.isRegistered<InventoryCubit>()) {
    sl.registerFactory(() => InventoryCubit());
  }
  if (!sl.isRegistered<InvoiceCubit>()) {
    sl.registerFactory(() => InvoiceCubit());
  }
  if (!sl.isRegistered<ReportsCubit>()) {
    sl.registerFactory(() => ReportsCubit());
  }

  // External (Firebase)
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton(() => FirebaseAuth.instance);
  }
}
