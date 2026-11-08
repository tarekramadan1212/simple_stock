import 'package:equatable/equatable.dart';

class PurchaseSummary extends Equatable {
  final double totalSpending;
  final int totalPurchasesCount;
  final DateTime? startDate;
  final DateTime? endDate;

  const PurchaseSummary({
    required this.totalSpending,
    required this.totalPurchasesCount,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        totalSpending,
        totalPurchasesCount,
        startDate,
        endDate,
      ];
}
