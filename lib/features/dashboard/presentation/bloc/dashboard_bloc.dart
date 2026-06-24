import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/usecases/get_metrics_usecase.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/usecases/get_alerts_usecase.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/today_stats.dart';
import 'package:crm_kurchudashboard/core/services/websocket_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetMetricsUseCase getMetricsUseCase;
  final GetAlertsUseCase getAlertsUseCase;
  final WebSocketService webSocketService;

  DashboardBloc({
    required this.getMetricsUseCase,
    required this.getAlertsUseCase,
    required this.webSocketService,
  }) : super(const DashboardState.initial()) {
    on<MetricsFetched>(_onMetricsFetched);
    on<AlertsFetched>(_onAlertsFetched);
    on<RefreshRequested>(_onRefreshRequested);
    on<MetricsUpdatedFromWebSocket>(_onMetricsUpdatedFromWebSocket);
    on<AlertReceivedFromWebSocket>(_onAlertReceivedFromWebSocket);
    on<WebSocketConnected>(_onWebSocketConnected);

    // Setup WebSocket listeners
    _setupWebSocketListeners();
  }

  Future<void> _onMetricsFetched(
    MetricsFetched event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardState.loading());
    
    final metricsResult = await getMetricsUseCase();
    final alertsResult = await getAlertsUseCase();

    metricsResult.fold(
      (failure) => emit(DashboardState.error(failure.toString())),
      (metrics) {
        alertsResult.fold(
          (failure) => emit(DashboardState.error(failure.toString())),
          (alerts) {
            // Fetch today stats as well
            emit(DashboardState.loaded(
              metrics: metrics,
              alerts: alerts,
              todayStats: TodayStats.empty(), // Or fetch from backend
              isWebSocketConnected: false,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAlertsFetched(
    AlertsFetched event,
    Emitter<DashboardState> emit,
  ) async {
    final alertsResult = await getAlertsUseCase();
    
    if (state is Loaded) {
      final currentState = state as Loaded;
      alertsResult.fold(
        (failure) => emit(DashboardState.error(failure.toString())),
        (alerts) => emit(currentState.copyWith(alerts: alerts)),
      );
    }
  }

  Future<void> _onRefreshRequested(
    RefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    add(const DashboardEvent.metricsFetched());
  }

  Future<void> _onMetricsUpdatedFromWebSocket(
    MetricsUpdatedFromWebSocket event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is Loaded) {
      final currentState = state as Loaded;
      final updatedMetrics = Metrics.fromJson(event.data);
      emit(currentState.copyWith(metrics: updatedMetrics));
    }
  }

  Future<void> _onAlertReceivedFromWebSocket(
    AlertReceivedFromWebSocket event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is Loaded) {
      final currentState = state as Loaded;
      final newAlert = Alert.fromJson(event.data);
      emit(currentState.copyWith(
        alerts: [newAlert, ...currentState.alerts],
      ));
    }
  }

  Future<void> _onWebSocketConnected(
    WebSocketConnected event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is Loaded) {
      final currentState = state as Loaded;
      emit(currentState.copyWith(isWebSocketConnected: true));
    }
  }

  void _setupWebSocketListeners() {
    webSocketService.metricsUpdateStream.listen((data) {
      add(DashboardEvent.metricsUpdatedFromWebSocket(data));
    });

    webSocketService.alertStream.listen((data) {
      add(DashboardEvent.alertReceivedFromWebSocket(data));
    });

    webSocketService.connectionStatusStream.listen((isConnected) {
      if (isConnected) {
        add(const DashboardEvent.webSocketConnected());
      }
    });
  }

  @override
  Future<void> close() {
    webSocketService.dispose();
    return super.close();
  }
}
