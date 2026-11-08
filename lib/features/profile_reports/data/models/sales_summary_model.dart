import '../../domain/entities/sales_summary.dart';

class SalesSummaryModel extends SalesSummary {
  const SalesSummaryModel({
    required super.totalRevenue,
    required super.totalInvoicesCount,
    super.startDate,
    super.endDate,
  });

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryModel(
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalInvoicesCount: json['totalInvoicesCount'] as int? ?? 0,
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
      'totalRevenue': totalRevenue,
      'totalInvoicesCount': totalInvoicesCount,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
