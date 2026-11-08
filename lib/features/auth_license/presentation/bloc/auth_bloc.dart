import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shop_profile.dart';
import '../../domain/usecases/login_with_email_password.dart';
import '../../domain/usecases/save_shop_profile.dart';
import '../../domain/usecases/validate_license.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ValidateLicense validateLicense;
  final SaveShopProfile saveShopProfile;
  final LoginWithEmailPassword loginWithEmailPassword;

  AuthBloc({
    required this.validateLicense,
    required this.saveShopProfile,
    required this.loginWithEmailPassword,
  }) : super(AuthInitial()) {
    on<ValidateLicenseSubmitted>(_onValidateLicenseSubmitted);
    on<RegisterShopSubmitted>(_onRegisterShopSubmitted);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onValidateLicenseSubmitted(
    ValidateLicenseSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await validateLicense(event.licenseKey);
    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (licenseInfo) {
        if (licenseInfo.isUsed) {
          emit(LicenseUsedState(licenseInfo));
        } else {
          emit(LicenseUnusedState(licenseInfo));
        }
      },
    );
  }

  Future<void> _onRegisterShopSubmitted(
    RegisterShopSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final profile = ShopProfile(
      tenantId: '',
      licenseKey: event.licenseKey,
      shopName: event.shopName,
      email: event.email,
      phoneNumber: event.phoneNumber,
      address: event.address,
      taxNumber: event.taxNumber,
      createdAt: DateTime.now(),
    );

    final params = SaveShopProfileParams(
      profile: profile,
      password: event.password,
    );

    final result = await saveShopProfile(params);
    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (savedProfile) => emit(AuthenticatedState(savedProfile)),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final params = LoginParams(
      email: event.email,
      password: event.password,
    );

    final result = await loginWithEmailPassword(params);
    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (shopProfile) => emit(AuthenticatedState(shopProfile)),
    );
  }
}
