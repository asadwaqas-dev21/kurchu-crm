import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_event.freezed.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.metricsFetched() = MetricsFetched;
  const factory DashboardEvent.alertsFetched() = AlertsFetched;
  const factory DashboardEvent.refreshRequested() = RefreshRequested;
  const factory DashboardEvent.alertMarkedAsRead(String alertId) = AlertMarkedAsRead;
  const factory DashboardEvent.webSocketConnected() = WebSocketConnected;
  const factory DashboardEvent.metricsUpdatedFromWebSocket(Map<String, dynamic> data) = MetricsUpdatedFromWebSocket;
  const factory DashboardEvent.alertReceivedFromWebSocket(Map<String, dynamic> data) = AlertReceivedFromWebSocket;
}
