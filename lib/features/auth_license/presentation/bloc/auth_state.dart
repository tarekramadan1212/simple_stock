import 'package:equatable/equatable.dart';
import '../../domain/entities/license_info.dart';
import '../../domain/entities/shop_profile.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LicenseUnusedState extends AuthState {
  final LicenseInfo licenseInfo;

  const LicenseUnusedState(this.licenseInfo);

  @override
  List<Object?> get props => [licenseInfo];
}

class LicenseUsedState extends AuthState {
  final LicenseInfo licenseInfo;

  const LicenseUsedState(this.licenseInfo);

  @override
  List<Object?> get props => [licenseInfo];
}

class AuthenticatedState extends AuthState {
  final ShopProfile shopProfile;

  const AuthenticatedState(this.shopProfile);

  @override
  List<Object?> get props => [shopProfile];
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
