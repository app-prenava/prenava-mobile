import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      
      debugPrint('${options.method} ${options.uri}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint('[${response.statusCode}] ${response.requestOptions.uri}');
      return handler.next(response);
    },
    onError: (error, handler) {
      final isPregnancyEndpoint = error.requestOptions.path.contains('/pregnancy-calculator/my');
      final is404 = error.response?.statusCode == 404;

      if (!is404 || !isPregnancyEndpoint) {
        debugPrint('[${error.response?.statusCode}] ERROR: ${error.requestOptions.uri}');
      }
      return handler.next(error);
    },
  ));

  return dio;
});

