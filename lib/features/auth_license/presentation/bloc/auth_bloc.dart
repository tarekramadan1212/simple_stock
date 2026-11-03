import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/validate_license.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ValidateLicense validateLicense;

  AuthBloc({required this.validateLicense}) : super(AuthInitial()) {
    on<ValidateLicenseSubmitted>((event, emit) async {
      emit(AuthLoading());
      final result = await validateLicense(event.licenseKey);
      result.fold(
        (failure) => emit(AuthErrorState(failure.message)),
        (isValid) => emit(LicenseValidState(event.licenseKey)),
      );
    });
  }
}
