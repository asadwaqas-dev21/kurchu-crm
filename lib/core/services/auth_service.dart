import 'package:hive/hive.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';

class AuthService {
  static const String _tokenBoxName = 'auth_tokens';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userBoxName = 'auth_user';

  late Box<String> _tokenBox;
  late Box<dynamic> _userBox;
  
  ApiClient get _apiClient => getIt<ApiClient>();

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

      final accessToken = response.data['data']['accessToken'] as String;
      final refreshToken = response.data['data']['refreshToken'] as String;
      final user = response.data['data']['user'] as Map<String, dynamic>;

      // Save tokens
      await _tokenBox.put(_accessTokenKey, accessToken);
      await _tokenBox.put(_refreshTokenKey, refreshToken);
      
      // Save user
      await _userBox.put('user', user);

      return true;
    } catch (e) {
      print('LOGIN EXCEPTION IN AUTHD: $e');
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

      final accessToken = response.data['data']['accessToken'] as String;
      final refreshToken = response.data['data']['refreshToken'] as String;
      final user = response.data['data']['user'] as Map<String, dynamic>;

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
        ApiConstants.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['data']['accessToken'] as String;
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
    if (user is Map) {
      return Map<String, dynamic>.from(user);
    }
    return null;
  }

  // Update Profile
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final response = await _apiClient.patch(
        ApiConstants.authUpdateProfile,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
        },
      );

      final user = response.data['data']['user'] as Map<String, dynamic>;
      await _userBox.put('user', user);
      return true;
    } catch (e) {
      print('UPDATE PROFILE EXCEPTION: $e');
      return false;
    }
  }

  // Get Notification Settings
  Future<Map<String, dynamic>?> getNotificationSettings() async {
    try {
      final response = await _apiClient.get('/auth/notification-settings');
      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      print('GET NOTIFICATION SETTINGS EXCEPTION: $e');
      return null;
    }
  }

  // Update Notification Settings
  Future<bool> updateNotificationSettings(Map<String, dynamic> settings) async {
    try {
      await _apiClient.put(
        '/auth/notification-settings',
        data: settings,
      );
      return true;
    } catch (e) {
      print('UPDATE NOTIFICATION SETTINGS EXCEPTION: $e');
      return false;
    }
  }
}
