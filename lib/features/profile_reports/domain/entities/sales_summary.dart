import 'package:equatable/equatable.dart';

class SalesSummary extends Equatable {
  final double totalRevenue;
  final int totalInvoicesCount;
  final DateTime? startDate;
  final DateTime? endDate;

  const SalesSummary({
    required this.totalRevenue,
    required this.totalInvoicesCount,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        totalInvoicesCount,
        startDate,
        endDate,
      ];
}
