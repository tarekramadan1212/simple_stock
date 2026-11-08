import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth_license/domain/entities/shop_profile.dart';
import '../../domain/entities/purchase_summary.dart';
import '../../domain/entities/sales_summary.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_data_source.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource remoteDataSource;

  ReportsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ShopProfile>> getShopProfile(String tenantId) async {
    try {
      final profile = await remoteDataSource.getShopProfile(tenantId);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SalesSummary>> getSalesSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await remoteDataSource.getSalesSummary(
        tenantId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PurchaseSummary>> getPurchaseSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final summary = await remoteDataSource.getPurchaseSummary(
        tenantId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(summary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
