import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sales_summary.dart';
import '../repositories/reports_repository.dart';

class ReportFilterParams extends Equatable {
  final String tenantId;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportFilterParams({
    required this.tenantId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [tenantId, startDate, endDate];
}

class GetSalesSummary implements UseCase<SalesSummary, ReportFilterParams> {
  final ReportsRepository repository;

  GetSalesSummary(this.repository);

  @override
  Future<Either<Failure, SalesSummary>> call(ReportFilterParams params) async {
    return await repository.getSalesSummary(
      params.tenantId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
