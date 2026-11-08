import 'package:equatable/equatable.dart';

class LicenseInfo extends Equatable {
  final String key;
  final bool isUsed;
  final String? assignedShopId;

  const LicenseInfo({
    required this.key,
    required this.isUsed,
    this.assignedShopId,
  });

  @override
  List<Object?> get props => [key, isUsed, assignedShopId];
}
