import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/shop_profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> validateLicense(String licenseKey);
  Future<Either<Failure, ShopProfile>> saveShopProfile(ShopProfile profile);
}
