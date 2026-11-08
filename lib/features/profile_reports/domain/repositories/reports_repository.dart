import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth_license/domain/entities/shop_profile.dart';
import '../entities/purchase_summary.dart';
import '../entities/sales_summary.dart';

abstract class ReportsRepository {
  Future<Either<Failure, ShopProfile>> getShopProfile(String tenantId);
  Future<Either<Failure, SalesSummary>> getSalesSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, PurchaseSummary>> getPurchaseSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}
