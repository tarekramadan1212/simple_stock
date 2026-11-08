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

class RegisterShopSubmitted extends AuthEvent {
  final String licenseKey;
  final String shopName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;
  final String? taxNumber;

  const RegisterShopSubmitted({
    required this.licenseKey,
    required this.shopName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
    this.taxNumber,
  });

  @override
  List<Object?> get props => [
        licenseKey,
        shopName,
        email,
        phoneNumber,
        address,
        password,
        taxNumber,
      ];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
