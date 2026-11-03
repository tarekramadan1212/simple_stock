import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop_profile.dart';
import '../repositories/auth_repository.dart';

class SaveShopProfile implements UseCase<ShopProfile, ShopProfile> {
  final AuthRepository repository;

  SaveShopProfile(this.repository);

  @override
  Future<Either<Failure, ShopProfile>> call(ShopProfile params) async {
    return await repository.saveShopProfile(params);
  }
}
