import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/models/metrics_model.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/models/alert_model.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/models/today_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<MetricsModel> getMetrics();
  Future<List<AlertModel>> getAlerts({int skip = 0, int limit = 10});
  Future<TodayStatsModel> getTodayStats();
  Future<Map<String, dynamic>> getChartData({
    String type = 'revenue',
    String period = 'month',
  });
  Future<void> markAlertAsRead(String alertId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MetricsModel> getMetrics() async {
    try {
      final response = await apiClient.get(
        ApiConstants.dashboardMetrics,
      );
      return MetricsModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch metrics: $e');
    }
  }

  @override
  Future<List<AlertModel>> getAlerts({int skip = 0, int limit = 10}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.dashboardAlerts,
        queryParameters: {'skip': skip, 'limit': limit},
      );
      
      final alertsData = response.data['data']['alerts'] as List;
      return alertsData
          .map((item) => AlertModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }

  @override
  Future<TodayStatsModel> getTodayStats() async {
    try {
      final response = await apiClient.get(
        ApiConstants.dashboardTodayStats,
      );
      return TodayStatsModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch today stats: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getChartData({
    String type = 'revenue',
    String period = 'month',
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.dashboardChartData,
        queryParameters: {'type': type, 'period': period},
      );
      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch chart data: $e');
    }
  }

  @override
  Future<void> markAlertAsRead(String alertId) async {
    try {
      await apiClient.patch(
        '${ApiConstants.dashboardAlerts}/$alertId/read',
        data: {},
      );
    } catch (e) {
      throw Exception('Failed to mark alert as read: $e');
    }
  }
}
