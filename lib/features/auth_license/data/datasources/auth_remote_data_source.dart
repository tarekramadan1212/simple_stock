import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/license_info_model.dart';
import '../models/shop_profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<LicenseInfoModel> validateLicense(String licenseKey);
  Future<ShopProfileModel> saveShopProfile(ShopProfileModel profileModel, String password);
  Future<ShopProfileModel> loginWithEmailPassword(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<LicenseInfoModel> validateLicense(String licenseKey) async {
    try {
      final docRef = firestore.collection('licenses').doc(licenseKey);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        throw const InvalidLicenseException('Invalid license key. Document does not exist.');
      }

      final data = docSnap.data();
      if (data == null) {
        throw const InvalidLicenseException('License key data is invalid.');
      }

      return LicenseInfoModel.fromJson(data, docSnap.id);
    } on InvalidLicenseException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ShopProfileModel> saveShopProfile(ShopProfileModel profileModel, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: profileModel.email,
        password: password,
      );

      final tenantId = userCredential.user?.uid;
      if (tenantId == null) {
        throw const AuthException('User creation failed. Invalid user UID.');
      }

      final updatedModel = ShopProfileModel(
        tenantId: tenantId,
        licenseKey: profileModel.licenseKey,
        shopName: profileModel.shopName,
        email: profileModel.email,
        phoneNumber: profileModel.phoneNumber,
        address: profileModel.address,
        taxNumber: profileModel.taxNumber,
        createdAt: profileModel.createdAt,
      );

      // Save shop profile under /shops/{tenantId}/profile/details
      await firestore
          .collection('shops')
          .doc(tenantId)
          .collection('profile')
          .doc('details')
          .set(updatedModel.toJson());

      // Update license document to mark isUsed = true and link tenantId
      await firestore.collection('licenses').doc(profileModel.licenseKey).update({
        'isUsed': true,
        'assignedShopId': tenantId,
      });

      return updatedModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication error');
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Database error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ShopProfileModel> loginWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final tenantId = userCredential.user?.uid;
      if (tenantId == null) {
        throw const AuthException('Login failed. User UID not found.');
      }

      final docSnap = await firestore
          .collection('shops')
          .doc(tenantId)
          .collection('profile')
          .doc('details')
          .get();

      if (!docSnap.exists || docSnap.data() == null) {
        throw const ServerException('Shop profile document not found.');
      }

      return ShopProfileModel.fromJson(docSnap.data()!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication error');
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Database error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
