import 'package:dartz/dartz.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/repositories/dashboard_repository.dart';

class MarkAlertAsReadUseCase {
  final DashboardRepository repository;

  MarkAlertAsReadUseCase(this.repository);

  Future<Either<Exception, void>> call(String alertId) {
    return repository.markAlertAsRead(alertId);
  }
}
