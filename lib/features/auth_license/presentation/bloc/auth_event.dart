import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class ValidateLicenseSubmitted extends AuthEvent {
  final String licenseKey;

  const ValidateLicenseSubmitted(this.licenseKey);

  @override
  List<Object?> get props => [licenseKey];
}
