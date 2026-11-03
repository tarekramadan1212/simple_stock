import 'package:equatable/equatable.dart';

class ShopProfile extends Equatable {
  final String tenantId;
  final String licenseKey;
  final String shopName;
  final String ownerName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? taxNumber;
  final DateTime createdAt;

  const ShopProfile({
    required this.tenantId,
    required this.licenseKey,
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.taxNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        tenantId,
        licenseKey,
        shopName,
        ownerName,
        email,
        phoneNumber,
        address,
        taxNumber,
        createdAt,
      ];
}
