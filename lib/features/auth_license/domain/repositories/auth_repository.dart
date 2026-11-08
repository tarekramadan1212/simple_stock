import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/license_info.dart';
import '../entities/shop_profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, LicenseInfo>> validateLicense(String licenseKey);
  Future<Either<Failure, ShopProfile>> saveShopProfile({
    required ShopProfile profile,
    required String password,
  });
  Future<Either<Failure, ShopProfile>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}
