import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/purchase_summary.dart';
import '../repositories/reports_repository.dart';
import 'get_sales_summary.dart';

class GetPurchaseSummary implements UseCase<PurchaseSummary, ReportFilterParams> {
  final ReportsRepository repository;

  GetPurchaseSummary(this.repository);

  @override
  Future<Either<Failure, PurchaseSummary>> call(ReportFilterParams params) async {
    return await repository.getPurchaseSummary(
      params.tenantId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
