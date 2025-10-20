import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env.dart';
import '../../shared/services/secure_store.dart';

final appDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
    },
  ));

  // Add interceptor to attach JWT token
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Get token from secure storage (must match key in auth_repository_impl.dart)
      final token = await SecureStore().read('jwt_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        
        // Debug log (only in development)
        if (kDebugMode) {
          print('🔐 [Dio] Token attached to ${options.method} ${options.path}');
          print('🔐 [Dio] Token preview: ${token.substring(0, 20)}...');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ [Dio] No token found for ${options.method} ${options.path}');
        }
      }
      return handler.next(options);
    },
    onError: (error, handler) {
      // Debug log errors
      if (kDebugMode) {
        print('❌ [Dio] Error ${error.response?.statusCode}: ${error.message}');
        if (error.response?.data != null) {
          print('❌ [Dio] Response: ${error.response?.data}');
        }
      }
      return handler.next(error);
    },
  ));

  return dio;
});

