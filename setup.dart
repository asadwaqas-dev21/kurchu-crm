import 'dart:io';

import 'package:flutter/foundation.dart';

void main() {
  final Map<String, String> files = {
    // core/constants
    'lib/core/constants/app_colors.dart': '''
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C5DD3);
  static const Color secondary = Color(0xFF1DB954);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
}
''',
    'lib/core/constants/api_constants.dart': '''
class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:3001/api';
  static const String wsUrl = 'ws://127.0.0.1:3001/ws/dashboard';

  // Auth endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authMe = '/auth/me';
  static const String authUpdateProfile = '/auth/update-profile';
  static const String authLogout = '/auth/logout';

  // Dashboard endpoints
  static const String dashboardMetrics = '/dashboard/metrics';
  static const String dashboardAlerts = '/dashboard/alerts';
  static const String dashboardTodayStats = '/dashboard/today-stats';
  static const String dashboardChartData = '/dashboard/chart-data';

  // Company endpoints
  static const String companyProfile = '/company/profile';
  static const String companyServices = '/company/services';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
''',
    'lib/core/services/auth_service.dart': '''
import 'package:hive/hive.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';

class AuthService {
  static const String _tokenBoxName = 'auth_tokens';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userBoxName = 'auth_user';

  late Box<String> _tokenBox;
  late Box<dynamic> _userBox;
  late ApiClient _apiClient;

  Future<void> initialize() async {
    _tokenBox = await Hive.openBox<String>(_tokenBoxName);
    _userBox = await Hive.openBox<dynamic>(_userBoxName);
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      final accessToken = response.data['accessToken'] as String;
      final refreshToken = response.data['refreshToken'] as String;
      final user = response.data['user'] as Map<String, dynamic>;

      // Save tokens
      await _tokenBox.put(_accessTokenKey, accessToken);
      await _tokenBox.put(_refreshTokenKey, refreshToken);
      
      // Save user
      await _userBox.put('user', user);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String companyName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.authRegister,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'companyName': companyName,
        },
      );

      final accessToken = response.data['accessToken'] as String;
      final refreshToken = response.data['refreshToken'] as String;
      final user = response.data['user'] as Map<String, dynamic>;

      await _tokenBox.put(_accessTokenKey, accessToken);
      await _tokenBox.put(_refreshTokenKey, refreshToken);
      await _userBox.put('user', user);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get stored tokens
  String? getAccessToken() => _tokenBox.get(_accessTokenKey);
  String? getRefreshToken() => _tokenBox.get(_refreshTokenKey);

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiClient.post(
        ApiConstants.authLogin,
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'] as String;
      await _tokenBox.put(_accessTokenKey, newAccessToken);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _tokenBox.delete(_accessTokenKey);
    await _tokenBox.delete(_refreshTokenKey);
    await _userBox.delete('user');
  }

  // Check if logged in
  bool isLoggedIn() => getAccessToken() != null;

  // Get current user
  Map<String, dynamic>? getCurrentUser() {
    final user = _userBox.get('user');
    return user is Map<String, dynamic> ? user : null;
  }
}
''',
    'lib/core/services/api_client.dart': '''
import 'package:dio/dio.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';

class ApiClient {
  late Dio _dio;
  final AuthService authService;

  ApiClient({required this.authService}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl, // http://localhost:3001/api
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_createInterceptor());
  }

  Interceptor _createInterceptor() => InterceptorsWrapper(
    onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      // Add JWT token to headers
      final token = authService.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer \$token';
      }
      return handler.next(options);
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      return handler.next(response);
    },
    onError: (DioException error, ErrorInterceptorHandler handler) async {
      // Handle 401 - refresh token
      if (error.response?.statusCode == 401) {
        try {
          final refreshed = await authService.refreshToken();
          if (refreshed) {
            // Retry request with new token
            final options = error.requestOptions;
            final token = authService.getAccessToken();
            options.headers['Authorization'] = 'Bearer \$token';
            return handler.resolve(await _dio.request(
              options.path,
              options: options,
            ));
          }
        } catch (e) {
          // Logout user
          await authService.logout();
        }
      }
      return handler.next(error);
    },
  );

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  // POST request
  Future<Response> post(
    String path, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    required dynamic data,
  }) {
    return _dio.patch(path, data: data);
  }

  // DELETE request
  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
''',
    'lib/core/services/websocket_service.dart': '''
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:async';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';

class WebSocketService {
  late io.Socket socket;
  final AuthService authService;
  
  final _metricsUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _alertController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get metricsUpdateStream => _metricsUpdateController.stream;
  Stream<Map<String, dynamic>> get alertStream => _alertController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  WebSocketService({required this.authService});

  Future<void> connect() async {
    final token = authService.getAccessToken();
    
    socket = io.io(
      ApiConstants.wsUrl,
      io.SocketIoClientOptions(
        auth: {'token': token},
        reconnection: true,
        reconnectionDelay: 1000,
        reconnectionDelayMax: 5000,
        reconnectionAttempts: 10,
      ),
    );

    // Connection events
    socket.on('connect', (_) {
      _connectionStatusController.add(true);
      print('✅ WebSocket connected');
    });

    socket.on('disconnect', (_) {
      _connectionStatusController.add(false);
      print('❌ WebSocket disconnected');
    });

    socket.on('connect_error', (error) {
      print('❌ WebSocket connection error: \$error');
    });

    // Dashboard events
    socket.on('metrics:update', (data) {
      _metricsUpdateController.add(data as Map<String, dynamic>);
    });

    socket.on('alert:new', (data) {
      _alertController.add(data as Map<String, dynamic>);
    });

    socket.on('lead:created', (data) {
      // Handle new lead
      final alert = {
        'type': 'NEW_LEAD',
        'title': 'New Lead',
        'message': '\${data['firstName']} \${data['lastName']} added',
        'severity': 'INFO',
      };
      _alertController.add(alert);
    });
  }

  // Subscribe to dashboard updates
  void subscribeToDashboard() {
    socket.emit('dashboard:subscribe', {});
  }

  void dispose() {
    _metricsUpdateController.close();
    _alertController.close();
    _connectionStatusController.close();
    socket.dispose();
  }
}
''',
    'lib/features/dashboard/data/models/metrics_model.dart': '''
import 'package:json_annotation/json_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';

part 'metrics_model.g.dart';

@JsonSerializable()
class MetricsModel {
  final int totalLeads;
  final int newLeadsToday;
  final int callsToday;
  final int bookingsThisMonth;
  final double pendingPayments;
  final double totalRevenue;
  final double collectedAmount;
  final String conversionRate;
  final String averageDealValue;
  final String timestamp;

  MetricsModel({
    required this.totalLeads,
    required this.newLeadsToday,
    required this.callsToday,
    required this.bookingsThisMonth,
    required this.pendingPayments,
    required this.totalRevenue,
    required this.collectedAmount,
    required this.conversionRate,
    required this.averageDealValue,
    required this.timestamp,
  });

  factory MetricsModel.fromJson(Map<String, dynamic> json) =>
      _\$MetricsModelFromJson(json);

  Map<String, dynamic> toJson() => _\$MetricsModelToJson(this);

  Metrics toEntity() {
    return Metrics(
      totalLeads: totalLeads,
      newLeadsToday: newLeadsToday,
      callsToday: callsToday,
      bookingsThisMonth: bookingsThisMonth,
      pendingPayments: pendingPayments,
      totalRevenue: totalRevenue,
      collectedAmount: collectedAmount,
      conversionRate: conversionRate,
      averageDealValue: averageDealValue,
      timestamp: timestamp,
    );
  }
}
''',
    'lib/features/dashboard/domain/entities/metrics.dart': '''
class Metrics {
  final int totalLeads;
  final int newLeadsToday;
  final int callsToday;
  final int bookingsThisMonth;
  final double pendingPayments;
  final double totalRevenue;
  final double collectedAmount;
  final String conversionRate;
  final String averageDealValue;
  final String timestamp;

  Metrics({
    required this.totalLeads,
    required this.newLeadsToday,
    required this.callsToday,
    required this.bookingsThisMonth,
    required this.pendingPayments,
    required this.totalRevenue,
    required this.collectedAmount,
    required this.conversionRate,
    required this.averageDealValue,
    required this.timestamp,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      totalLeads: json['totalLeads'] ?? 0,
      newLeadsToday: json['newLeadsToday'] ?? 0,
      callsToday: json['callsToday'] ?? 0,
      bookingsThisMonth: json['bookingsThisMonth'] ?? 0,
      pendingPayments: (json['pendingPayments'] ?? 0).toDouble(),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      collectedAmount: (json['collectedAmount'] ?? 0).toDouble(),
      conversionRate: json['conversionRate'] ?? '',
      averageDealValue: json['averageDealValue'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
''',
    'lib/features/dashboard/data/models/alert_model.dart': '''
import 'package:json_annotation/json_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';

part 'alert_model.g.dart';

enum AlertType {
  @JsonValue('NEW_LEAD')
  newLead,
  @JsonValue('FOLLOW_UP_OVERDUE')
  followUpOverdue,
  @JsonValue('PAYMENT_DUE')
  paymentDue,
  @JsonValue('BOOKING_COMPLETED')
  bookingCompleted,
  @JsonValue('INVOICE_SENT')
  invoiceSent,
}

enum AlertSeverity {
  @JsonValue('INFO')
  info,
  @JsonValue('WARNING')
  warning,
  @JsonValue('ERROR')
  error,
  @JsonValue('CRITICAL')
  critical,
}

@JsonSerializable()
class AlertModel {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final AlertSeverity severity;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _\$AlertModelFromJson(json);

  Map<String, dynamic> toJson() => _\$AlertModelToJson(this);

  Alert toEntity() {
    return Alert(
      id: id,
      type: type.toString().split('.').last,
      title: title,
      message: message,
      severity: severity.toString().split('.').last,
      isRead: isRead,
      readAt: readAt,
      createdAt: createdAt,
    );
  }
}
''',
    'lib/features/dashboard/domain/entities/alert.dart': '''
class Alert {
  final String id;
  final String type;
  final String title;
  final String message;
  final String severity;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  Alert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      severity: json['severity'] ?? 'INFO',
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
''',
    'lib/features/dashboard/data/models/today_stats_model.dart': '''
import 'package:json_annotation/json_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/today_stats.dart';

part 'today_stats_model.g.dart';

@JsonSerializable()
class TodayStatsModel {
  final int totalLeads;
  final int totalBookings;

  TodayStatsModel({
    required this.totalLeads,
    required this.totalBookings,
  });

  factory TodayStatsModel.fromJson(Map<String, dynamic> json) =>
      _\$TodayStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _\$TodayStatsModelToJson(this);

  TodayStats toEntity() {
    return TodayStats(
      totalLeads: totalLeads,
      totalBookings: totalBookings,
    );
  }
}
''',
    'lib/features/dashboard/domain/entities/today_stats.dart': '''
class TodayStats {
  final int totalLeads;
  final int totalBookings;

  TodayStats({
    required this.totalLeads,
    required this.totalBookings,
  });

  factory TodayStats.empty() {
    return TodayStats(totalLeads: 0, totalBookings: 0);
  }
}
''',
    'lib/features/dashboard/data/datasources/dashboard_remote_data_source.dart':
        '''
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
      return MetricsModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch metrics: \$e');
    }
  }

  @override
  Future<List<AlertModel>> getAlerts({int skip = 0, int limit = 10}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.dashboardAlerts,
        queryParameters: {'skip': skip, 'limit': limit},
      );
      
      final alertsData = response.data['alerts'] as List;
      return alertsData
          .map((item) => AlertModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch alerts: \$e');
    }
  }

  @override
  Future<TodayStatsModel> getTodayStats() async {
    try {
      final response = await apiClient.get(
        ApiConstants.dashboardTodayStats,
      );
      return TodayStatsModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch today stats: \$e');
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
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch chart data: \$e');
    }
  }

  @override
  Future<void> markAlertAsRead(String alertId) async {
    try {
      await apiClient.patch(
        '\${ApiConstants.dashboardAlerts}/\$alertId/read',
        data: {},
      );
    } catch (e) {
      throw Exception('Failed to mark alert as read: \$e');
    }
  }
}
''',
    'lib/features/dashboard/data/datasources/dashboard_local_data_source.dart':
        '''
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
''',
    'lib/features/dashboard/domain/repositories/dashboard_repository.dart': '''
import 'package:dartz/dartz.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';

abstract class DashboardRepository {
  Future<Either<Exception, Metrics>> getMetrics();
  Future<Either<Exception, List<Alert>>> getAlerts({int skip = 0, int limit = 10});
  Future<Either<Exception, void>> markAlertAsRead(String alertId);
}
''',
    'lib/features/dashboard/data/repositories/dashboard_repository_impl.dart':
        '''
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
      return Left(Exception('Failed to fetch metrics: \$e'));
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
      return Left(Exception('Failed to fetch alerts: \$e'));
    }
  }

  @override
  Future<Either<Exception, void>> markAlertAsRead(String alertId) async {
    try {
      await remoteDataSource.markAlertAsRead(alertId);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to mark alert as read: \$e'));
    }
  }
}
''',
    'lib/features/dashboard/domain/usecases/get_metrics_usecase.dart': '''
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
''',
    'lib/features/dashboard/domain/usecases/get_alerts_usecase.dart': '''
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
''',
    'lib/features/dashboard/presentation/bloc/dashboard_event.dart': '''
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_event.freezed.dart';

@freezed
class DashboardEvent with _\$DashboardEvent {
  const factory DashboardEvent.metricsFetched() = MetricsFetched;
  const factory DashboardEvent.alertsFetched() = AlertsFetched;
  const factory DashboardEvent.refreshRequested() = RefreshRequested;
  const factory DashboardEvent.alertMarkedAsRead(String alertId) = AlertMarkedAsRead;
  const factory DashboardEvent.webSocketConnected() = WebSocketConnected;
  const factory DashboardEvent.metricsUpdatedFromWebSocket(Map<String, dynamic> data) = MetricsUpdatedFromWebSocket;
  const factory DashboardEvent.alertReceivedFromWebSocket(Map<String, dynamic> data) = AlertReceivedFromWebSocket;
}
''',
    'lib/features/dashboard/presentation/bloc/dashboard_state.dart': '''
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/today_stats.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _\$DashboardState {
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
''',
    'lib/features/dashboard/presentation/bloc/dashboard_bloc.dart': '''
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
''',
    'lib/features/dashboard/presentation/widgets/kpi_card.dart': '''
import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
''',
    'lib/features/dashboard/presentation/widgets/alert_banner.dart': '''
import 'package:flutter/material.dart';

class AlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final String severity;

  const AlertBanner({
    Key? key,
    required this.title,
    required this.message,
    required this.severity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bannerColor = Colors.blue;
    IconData bannerIcon = Icons.info;
    
    if (severity == 'WARNING') {
      bannerColor = Colors.orange;
      bannerIcon = Icons.warning;
    } else if (severity == 'ERROR' || severity == 'CRITICAL') {
      bannerColor = Colors.red;
      bannerIcon = Icons.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bannerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bannerColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(bannerIcon, color: bannerColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: bannerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
''',
    'lib/features/dashboard/presentation/widgets/quick_stats.dart': '''
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/today_stats.dart';

class QuickStats extends StatelessWidget {
  final TodayStats todayStats;

  const QuickStats({Key? key, required this.todayStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Stats', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Leads', todayStats.totalLeads.toString()),
                _buildStatItem('Total Bookings', todayStats.totalBookings.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
''',
    'lib/features/dashboard/presentation/pages/dashboard_page.dart': '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/alert_banner.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/quick_stats.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch metrics on page load
    context.read<DashboardBloc>().add(const DashboardEvent.metricsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(
                const DashboardEvent.refreshRequested(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (metrics, alerts, todayStats, isWebSocketConnected) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(
                    const DashboardEvent.refreshRequested(),
                  );
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPI Cards Grid
                      GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          KpiCard(
                            title: 'Total Leads',
                            value: '\${metrics.totalLeads}',
                            icon: Icons.people,
                            color: AppColors.primary,
                          ),
                          KpiCard(
                            title: 'New Today',
                            value: '\${metrics.newLeadsToday}',
                            icon: Icons.trending_up,
                            color: AppColors.success,
                          ),
                          KpiCard(
                            title: 'Calls Today',
                            value: '\${metrics.callsToday}',
                            icon: Icons.call,
                            color: AppColors.warning,
                          ),
                          KpiCard(
                            title: 'Revenue',
                            value: '\\\$\${metrics.totalRevenue.toStringAsFixed(0)}',
                            icon: Icons.attach_money,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // WebSocket Connection Status
                      if (isWebSocketConnected)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.success),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '🔴 Real-time updates live',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Alerts
                      if (alerts.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alerts',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            ...alerts.take(3).map((alert) => AlertBanner(
                              title: alert.title,
                              message: alert.message,
                              severity: alert.severity,
                            )),
                          ],
                        ),

                      const SizedBox(height: 24),

                      // Today Stats
                      QuickStats(todayStats: todayStats),
                    ],
                  ),
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: \$message',
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(
                        const DashboardEvent.refreshRequested(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
''',
    'lib/core/di/injection.dart': '''
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';
import 'package:crm_kurchudashboard/core/services/websocket_service.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/usecases/get_metrics_usecase.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/usecases/get_alerts_usecase.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// Manual registrations for now, as we don't have the generated file yet
extension GetItInjectableX on GetIt {
  void init() {
    this.registerLazySingleton<AuthService>(() => AuthService());
    this.registerLazySingleton<ApiClient>(() => ApiClient(authService: this()));
    this.registerLazySingleton<WebSocketService>(() => WebSocketService(authService: this()));

    this.registerLazySingleton<DashboardRemoteDataSource>(
        () => DashboardRemoteDataSourceImpl(apiClient: this()));
    this.registerLazySingleton<DashboardLocalDataSource>(
        () => DashboardLocalDataSourceImpl());

    this.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: this(),
        localDataSource: this(),
      ),
    );

    this.registerLazySingleton<GetMetricsUseCase>(() => GetMetricsUseCase(this()));
    this.registerLazySingleton<GetAlertsUseCase>(() => GetAlertsUseCase(this()));

    this.registerFactory<DashboardBloc>(() => DashboardBloc(
          getMetricsUseCase: this(),
          getAlertsUseCase: this(),
          webSocketService: this(),
        ));
    
    // AuthBloc is a placeholder for now
    this.registerFactory<AuthBloc>(() => AuthBloc());
  }
}
''',
    'lib/core/router/app_router.dart': '''
import 'package:go_router/go_router.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/pages/dashboard_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
''',
    'lib/core/theme/app_theme.dart': '''
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primary,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
''',
    'lib/features/auth/presentation/bloc/auth_bloc.dart': '''
import 'package:flutter_bloc/flutter_bloc.dart';

// Placeholder AuthBloc
class AuthBloc extends Cubit<int> {
  AuthBloc() : super(0);
}
''',
    'lib/main.dart': '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/core/router/app_router.dart';
import 'package:crm_kurchudashboard/core/theme/app_theme.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';
import 'package:crm_kurchudashboard/core/services/websocket_service.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:crm_kurchudashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Setup dependency injection
  configureDependencies();
  
  // Initialize auth service
  final authService = getIt<AuthService>();
  await authService.initialize();
  
  final localData = getIt<DashboardLocalDataSource>();
  await (localData as DashboardLocalDataSourceImpl).initialize();
  
  // Initialize WebSocket service
  final webSocketService = getIt<WebSocketService>();
  if (authService.isLoggedIn()) {
    await webSocketService.connect();
  }

  runApp(const KurchuCrmApp());
}

class KurchuCrmApp extends StatelessWidget {
  const KurchuCrmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<DashboardBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Kurchu CRM',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
''',
  };

  for (final entry in files.entries) {
    final file = File(entry.key);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    if (kDebugMode) {
      print('Created \${entry.key}');
    }
  }
}
