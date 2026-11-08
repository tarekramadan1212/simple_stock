import '../../domain/entities/purchase_summary.dart';

class PurchaseSummaryModel extends PurchaseSummary {
  const PurchaseSummaryModel({
    required super.totalSpending,
    required super.totalPurchasesCount,
    super.startDate,
    super.endDate,
  });

  factory PurchaseSummaryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseSummaryModel(
      totalSpending: (json['totalSpending'] as num?)?.toDouble() ?? 0.0,
      totalPurchasesCount: json['totalPurchasesCount'] as int? ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSpending': totalSpending,
      'totalPurchasesCount': totalPurchasesCount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
