import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/shop_profile.dart';

class ShopProfileModel extends ShopProfile {
  const ShopProfileModel({
    required super.tenantId,
    required super.licenseKey,
    required super.shopName,
    required super.email,
    required super.phoneNumber,
    required super.address,
    super.taxNumber,
    required super.createdAt,
  });

  factory ShopProfileModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedCreatedAt;
    if (json['createdAt'] is Timestamp) {
      parsedCreatedAt = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      parsedCreatedAt = DateTime.parse(json['createdAt'] as String);
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return ShopProfileModel(
      tenantId: json['tenantId'] as String? ?? '',
      licenseKey: json['licenseKey'] as String? ?? '',
      shopName: json['shopName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
      taxNumber: json['taxNumber'] as String?,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'licenseKey': licenseKey,
      'shopName': shopName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'taxNumber': taxNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
