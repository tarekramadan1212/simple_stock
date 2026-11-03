import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/shop_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/shop_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> validateLicense(String licenseKey) async {
    try {
      final isValid = await remoteDataSource.validateLicense(licenseKey);
      if (isValid) {
        return const Right(true);
      } else {
        return const Left(InvalidLicenseFailure());
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopProfile>> saveShopProfile(ShopProfile profile) async {
    try {
      final model = ShopProfileModel(
        tenantId: profile.tenantId,
        licenseKey: profile.licenseKey,
        shopName: profile.shopName,
        ownerName: profile.ownerName,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        address: profile.address,
        taxNumber: profile.taxNumber,
        createdAt: profile.createdAt,
      );
      final result = await remoteDataSource.saveShopProfile(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
