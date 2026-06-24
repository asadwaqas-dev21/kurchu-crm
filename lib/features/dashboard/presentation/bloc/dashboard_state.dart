import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/today_stats.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = Initial;
  const factory DashboardState.loading() = Loading;
  const factory DashboardState.loaded({
    required Metrics metrics,
    required List<Alert> alerts,
    required TodayStats todayStats,
    required bool isWebSocketConnected,
  }) = Loaded;
  const factory DashboardState.error(String message) = Error;
}
