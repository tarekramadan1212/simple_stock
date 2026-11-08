import '../../domain/entities/license_info.dart';

class LicenseInfoModel extends LicenseInfo {
  const LicenseInfoModel({
    required super.key,
    required super.isUsed,
    super.assignedShopId,
  });

  factory LicenseInfoModel.fromJson(Map<String, dynamic> json, String docId) {
    return LicenseInfoModel(
      key: docId,
      isUsed: json['isUsed'] as bool? ?? false,
      assignedShopId: json['assignedShopId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': key,
      'isUsed': isUsed,
      'assignedShopId': assignedShopId,
    };
  }
}
