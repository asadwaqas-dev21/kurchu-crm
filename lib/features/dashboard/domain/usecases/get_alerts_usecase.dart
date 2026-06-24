import 'package:dartz/dartz.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetAlertsUseCase {
  final DashboardRepository repository;

  GetAlertsUseCase(this.repository);

  Future<Either<Exception, List<Alert>>> call({int skip = 0, int limit = 10}) {
    return repository.getAlerts(skip: skip, limit: limit);
  }
}
