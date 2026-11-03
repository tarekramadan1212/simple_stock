import '../../domain/entities/shop_profile.dart';

class ShopProfileModel extends ShopProfile {
  const ShopProfileModel({
    required super.tenantId,
    required super.licenseKey,
    required super.shopName,
    required super.ownerName,
    required super.email,
    required super.phoneNumber,
    required super.address,
    super.taxNumber,
    required super.createdAt,
  });

  factory ShopProfileModel.fromJson(Map<String, dynamic> json) {
    return ShopProfileModel(
      tenantId: json['tenantId'] as String,
      licenseKey: json['licenseKey'] as String,
      shopName: json['shopName'] as String,
      ownerName: json['ownerName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      taxNumber: json['taxNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'licenseKey': licenseKey,
      'shopName': shopName,
      'ownerName': ownerName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'taxNumber': taxNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
