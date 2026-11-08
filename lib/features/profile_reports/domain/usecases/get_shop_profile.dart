import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth_license/domain/entities/shop_profile.dart';
import '../repositories/reports_repository.dart';

class GetShopProfile implements UseCase<ShopProfile, String> {
  final ReportsRepository repository;

  GetShopProfile(this.repository);

  @override
  Future<Either<Failure, ShopProfile>> call(String tenantId) async {
    return await repository.getShopProfile(tenantId);
  }
}
