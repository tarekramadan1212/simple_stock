import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/license_info.dart';
import '../repositories/auth_repository.dart';

class ValidateLicense implements UseCase<LicenseInfo, String> {
  final AuthRepository repository;

  ValidateLicense(this.repository);

  @override
  Future<Either<Failure, LicenseInfo>> call(String licenseKey) async {
    return await repository.validateLicense(licenseKey);
  }
}
