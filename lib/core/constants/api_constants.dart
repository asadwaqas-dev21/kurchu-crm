class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:3001/api';
  static const String wsUrl = 'ws://127.0.0.1:3001/ws/dashboard';

  // Auth endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh-token';
  static const String authMe = '/auth/me';
  static const String authUpdateProfile = '/auth/update-profile';
  static const String authLogout = '/auth/logout';

  // Dashboard
  static const String dashboardMetrics = '/dashboard/metrics';
  static const String dashboardAlerts = '/dashboard/alerts';

  // CRM Entities
  static const String leads = '/leads';
  static const String followUps = '/follow-ups';
  static const String bookings = '/bookings';

  static const String invoices = '/invoices';
  static const String documents = '/documents';
  static const String dashboardTodayStats = '/dashboard/today-stats';
  static const String dashboardChartData = '/dashboard/chart-data';

  // Company endpoints
  static const String companyProfile = '/company/profile';
  static const String companyServices = '/company/services';


  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
