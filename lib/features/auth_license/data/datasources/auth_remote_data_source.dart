import '../models/shop_profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> validateLicense(String licenseKey);
  Future<ShopProfileModel> saveShopProfile(ShopProfileModel profileModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> validateLicense(String licenseKey) async {
    // TODO: Implement Firestore validation
    return true;
  }

  @override
  Future<ShopProfileModel> saveShopProfile(ShopProfileModel profileModel) async {
    // TODO: Implement Firestore tenant creation and save profile
    return profileModel;
  }
}
