import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop_profile.dart';
import '../repositories/auth_repository.dart';

class SaveShopProfileParams extends Equatable {
  final ShopProfile profile;
  final String password;

  const SaveShopProfileParams({
    required this.profile,
    required this.password,
  });

  @override
  List<Object?> get props => [profile, password];
}

class SaveShopProfile implements UseCase<ShopProfile, SaveShopProfileParams> {
  final AuthRepository repository;

  SaveShopProfile(this.repository);

  @override
  Future<Either<Failure, ShopProfile>> call(SaveShopProfileParams params) async {
    return await repository.saveShopProfile(
      profile: params.profile,
      password: params.password,
    );
  }
}
