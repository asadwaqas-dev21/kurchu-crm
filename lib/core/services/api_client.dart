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
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      return handler.next(response);
    },
    onError: (DioException error, ErrorInterceptorHandler handler) async {
      // Handle 401 - refresh token
      if (error.response?.statusCode == 401) {
        if (error.requestOptions.path.contains(ApiConstants.authRefresh) ||
            error.requestOptions.path.contains(ApiConstants.authLogin)) {
          await authService.logout();
          return handler.next(error);
        }

        try {
          final refreshed = await authService.refreshToken();
          if (refreshed) {
            // Retry request with new token
            final options = error.requestOptions;
            final token = authService.getAccessToken();
            options.headers['Authorization'] = 'Bearer $token';
            return handler.resolve(await _dio.fetch(options));
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

  // PUT request
  Future<Response> put(
    String path, {
    required dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.put(
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
