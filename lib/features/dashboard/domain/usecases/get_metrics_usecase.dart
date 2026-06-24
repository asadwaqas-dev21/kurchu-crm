import 'package:dartz/dartz.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetMetricsUseCase {
  final DashboardRepository repository;

  GetMetricsUseCase(this.repository);

  Future<Either<Exception, Metrics>> call() {
    return repository.getMetrics();
  }
}
