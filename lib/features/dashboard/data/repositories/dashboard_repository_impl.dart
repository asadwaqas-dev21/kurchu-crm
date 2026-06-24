import 'package:dartz/dartz.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Exception, Metrics>> getMetrics() async {
    try {
      // Try fetching from backend
      final metricsModel = await remoteDataSource.getMetrics();
      
      // Cache locally
      await localDataSource.cacheMetrics(metricsModel);
      
      // Convert to entity
      final metrics = metricsModel.toEntity();
      return Right(metrics);
    } catch (e) {
      // Fallback to cached data
      final cachedMetrics = await localDataSource.getCachedMetrics();
      if (cachedMetrics != null) {
        return Right(cachedMetrics.toEntity());
      }
      return Left(Exception('Failed to fetch metrics: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Alert>>> getAlerts({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final alertModels = await remoteDataSource.getAlerts(
        skip: skip,
        limit: limit,
      );
      
      await localDataSource.cacheAlerts(alertModels);
      
      final alerts = alertModels.map((m) => m.toEntity()).toList();
      return Right(alerts);
    } catch (e) {
      final cachedAlerts = await localDataSource.getCachedAlerts();
      if (cachedAlerts != null) {
        return Right(cachedAlerts.map((m) => m.toEntity()).toList());
      }
      return Left(Exception('Failed to fetch alerts: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> markAlertAsRead(String alertId) async {
    try {
      await remoteDataSource.markAlertAsRead(alertId);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to mark alert as read: $e'));
    }
  }
}
