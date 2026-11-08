import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_purchase_summary.dart';
import '../../domain/usecases/get_sales_summary.dart';
import '../../domain/usecases/get_shop_profile.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final GetShopProfile getShopProfile;
  final GetSalesSummary getSalesSummary;
  final GetPurchaseSummary getPurchaseSummary;

  ReportsCubit({
    required this.getShopProfile,
    required this.getSalesSummary,
    required this.getPurchaseSummary,
  }) : super(ReportsInitial());

  Future<void> loadReports(
    String tenantId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(ReportsLoading());

    final filterParams = ReportFilterParams(
      tenantId: tenantId,
      startDate: startDate,
      endDate: endDate,
    );

    final profileFuture = getShopProfile(tenantId);
    final salesFuture = getSalesSummary(filterParams);
    final purchaseFuture = getPurchaseSummary(filterParams);

    final results = await Future.wait([
      profileFuture,
      salesFuture,
      purchaseFuture,
    ]);

    final profileResult = results[0];
    final salesResult = results[1];
    final purchaseResult = results[2];

    String? errorMessage;

    profileResult.fold(
      (f) => errorMessage = f.message,
      (p) {},
    );

    salesResult.fold(
      (f) => errorMessage ??= f.message,
      (s) {},
    );

    purchaseResult.fold(
      (f) => errorMessage ??= f.message,
      (p) {},
    );

    if (errorMessage != null) {
      emit(ReportsError(errorMessage!));
      return;
    }

    final profile = profileResult.getOrElse(() => throw UnimplementedError());
    final sales = salesResult.getOrElse(() => throw UnimplementedError());
    final purchase = purchaseResult.getOrElse(() => throw UnimplementedError());

    emit(
      ReportsLoaded(
        shopProfile: profile as dynamic,
        salesSummary: sales as dynamic,
        purchaseSummary: purchase as dynamic,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }
}
