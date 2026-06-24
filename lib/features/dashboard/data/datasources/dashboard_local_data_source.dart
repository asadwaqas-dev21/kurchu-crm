import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/models/metrics_model.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/models/alert_model.dart';

abstract class DashboardLocalDataSource {
  Future<MetricsModel?> getCachedMetrics();
  Future<void> cacheMetrics(MetricsModel metrics);
  Future<List<AlertModel>?> getCachedAlerts();
  Future<void> cacheAlerts(List<AlertModel> alerts);
  Future<void> clearCache();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const String _metricsBoxName = 'dashboard_metrics';
  static const String _alertsBoxName = 'dashboard_alerts';
  static const String _metricsKey = 'metrics';
  static const String _alertsKey = 'alerts';

  late Box<String> _metricsBox;
  late Box<String> _alertsBox;

  Future<void> initialize() async {
    _metricsBox = await Hive.openBox<String>(_metricsBoxName);
    _alertsBox = await Hive.openBox<String>(_alertsBoxName);
  }

  @override
  Future<MetricsModel?> getCachedMetrics() async {
    try {
      final jsonString = _metricsBox.get(_metricsKey);
      if (jsonString == null) return null;
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return MetricsModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheMetrics(MetricsModel metrics) async {
    try {
      await _metricsBox.put(
        _metricsKey,
        jsonEncode(metrics.toJson()),
      );
    } catch (e) {
      // Silently fail caching
    }
  }

  @override
  Future<List<AlertModel>?> getCachedAlerts() async {
    try {
      final jsonString = _alertsBox.get(_alertsKey);
      if (jsonString == null) return null;
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => AlertModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheAlerts(List<AlertModel> alerts) async {
    try {
      final jsonList = alerts.map((a) => a.toJson()).toList();
      await _alertsBox.put(_alertsKey, jsonEncode(jsonList));
    } catch (e) {
      // Silently fail caching
    }
  }

  @override
  Future<void> clearCache() async {
    await _metricsBox.clear();
    await _alertsBox.clear();
  }
}
