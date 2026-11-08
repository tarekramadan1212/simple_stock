import 'package:equatable/equatable.dart';
import '../../../auth_license/domain/entities/shop_profile.dart';
import '../../domain/entities/purchase_summary.dart';
import '../../domain/entities/sales_summary.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final ShopProfile shopProfile;
  final SalesSummary salesSummary;
  final PurchaseSummary purchaseSummary;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportsLoaded({
    required this.shopProfile,
    required this.salesSummary,
    required this.purchaseSummary,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        shopProfile,
        salesSummary,
        purchaseSummary,
        startDate,
        endDate,
      ];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
