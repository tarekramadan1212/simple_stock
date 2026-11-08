import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth_license/data/models/shop_profile_model.dart';
import '../models/purchase_summary_model.dart';
import '../models/sales_summary_model.dart';

abstract class ReportsRemoteDataSource {
  Future<ShopProfileModel> getShopProfile(String tenantId);
  Future<SalesSummaryModel> getSalesSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<PurchaseSummaryModel> getPurchaseSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final FirebaseFirestore firestore;

  ReportsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<ShopProfileModel> getShopProfile(String tenantId) async {
    try {
      final docSnap = await firestore
          .collection('shops')
          .doc(tenantId)
          .collection('profile')
          .doc('details')
          .get();

      if (!docSnap.exists || docSnap.data() == null) {
        throw const ServerException('Shop profile details not found.');
      }

      return ShopProfileModel.fromJson(docSnap.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Firestore error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SalesSummaryModel> getSalesSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = firestore
          .collection('shops')
          .doc(tenantId)
          .collection('invoices');

      if (startDate != null) {
        query = query.where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }
      if (endDate != null) {
        query = query.where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        );
      }

      final querySnap = await query.get();
      double totalRevenue = 0.0;
      int invoiceCount = querySnap.docs.length;

      for (final doc in querySnap.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('totalAmount')) {
          final amount = data['totalAmount'];
          if (amount is num) {
            totalRevenue += amount.toDouble();
          }
        }
      }

      return SalesSummaryModel(
        totalRevenue: totalRevenue,
        totalInvoicesCount: invoiceCount,
        startDate: startDate,
        endDate: endDate,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Firestore error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PurchaseSummaryModel> getPurchaseSummary(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = firestore
          .collection('shops')
          .doc(tenantId)
          .collection('purchases');

      if (startDate != null) {
        query = query.where(
          'purchaseDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }
      if (endDate != null) {
        query = query.where(
          'purchaseDate',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        );
      }

      final querySnap = await query.get();
      double totalSpending = 0.0;
      int purchaseCount = querySnap.docs.length;

      for (final doc in querySnap.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('totalAmount')) {
          final amount = data['totalAmount'];
          if (amount is num) {
            totalSpending += amount.toDouble();
          }
        }
      }

      return PurchaseSummaryModel(
        totalSpending: totalSpending,
        totalPurchasesCount: purchaseCount,
        startDate: startDate,
        endDate: endDate,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Firestore error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
