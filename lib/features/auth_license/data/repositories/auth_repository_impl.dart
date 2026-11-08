import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/license_info.dart';
import '../../domain/entities/shop_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/shop_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LicenseInfo>> validateLicense(String licenseKey) async {
    try {
      final licenseInfo = await remoteDataSource.validateLicense(licenseKey);
      return Right(licenseInfo);
    } on InvalidLicenseException catch (e) {
      return Left(InvalidLicenseFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopProfile>> saveShopProfile({
    required ShopProfile profile,
    required String password,
  }) async {
    try {
      final model = ShopProfileModel(
        tenantId: profile.tenantId,
        licenseKey: profile.licenseKey,
        shopName: profile.shopName,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        address: profile.address,
        taxNumber: profile.taxNumber,
        createdAt: profile.createdAt,
      );

      final result = await remoteDataSource.saveShopProfile(model, password);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopProfile>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.loginWithEmailPassword(email, password);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
