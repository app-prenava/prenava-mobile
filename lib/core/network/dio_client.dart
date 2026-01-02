import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env.dart';
import '../../shared/services/secure_store.dart';

final appDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBase,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 60), // Longer for file uploads
    headers: {
      'Accept': 'application/json',
    },
  ));

  // Add interceptor to attach JWT token and log requests
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Skip Authorization header for auth endpoints (login/register)
      final path = options.path;
      final isAuthEndpoint = path.contains('/auth/login') || 
                             path.contains('/auth/register');
      
      if (!isAuthEndpoint) {
        final token = await SecureStore().read('jwt_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
      
      print('🌐 REQUEST: ${options.method} ${options.uri}');
      print('🔑 Headers: ${options.headers}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print('✅ RESPONSE [${response.statusCode}]: ${response.requestOptions.uri}');
      // Log response data for debugging community endpoints
      final path = response.requestOptions.path;
      if (path.contains('komunitas') || path.contains('threads') || path.contains('komen')) {
        print('📦 Response Data: ${response.data}');
      }
      return handler.next(response);
    },
    onError: (error, handler) {
      // Don't log 404 errors for pregnancy calculator endpoint (expected when no data)
      final isPregnancyEndpoint = error.requestOptions.path.contains('/pregnancy-calculator/my');
      final is404 = error.response?.statusCode == 404;

      if (!is404 || !isPregnancyEndpoint) {
        print('❌ ERROR [${error.response?.statusCode}]: ${error.requestOptions.uri}');
        print('❌ Message: ${error.response?.data}');
      }
      return handler.next(error);
    },
  ));

  return dio;
});

