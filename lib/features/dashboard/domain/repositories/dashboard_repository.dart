import 'package:dartz/dartz.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';

abstract class DashboardRepository {
  Future<Either<Exception, Metrics>> getMetrics();
  Future<Either<Exception, List<Alert>>> getAlerts({int skip = 0, int limit = 10});
  Future<Either<Exception, void>> markAlertAsRead(String alertId);
}
