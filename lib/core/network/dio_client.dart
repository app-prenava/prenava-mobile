import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/env.dart';
import '../../shared/services/secure_store.dart';

final appDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBase,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 90),
    sendTimeout: const Duration(seconds: 60),
    headers: {
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final path = options.path;
      final isAuthEndpoint = path.contains('/auth/login') ||
          path.contains('/auth/register') ||
          path.contains('/auth/forgot-password');

      if (!isAuthEndpoint) {
        final token = await SecureStore().read('jwt_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          debugPrint('[AUTH] Token attached for ${options.method} $path');
        } else {
          debugPrint('[AUTH] ⚠️ No token found for ${options.method} $path');
        }
      }

      debugPrint('${options.method} ${options.uri}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint('[${response.statusCode}] ${response.requestOptions.uri}');
      return handler.next(response);
    },
    onError: (error, handler) async {
      final statusCode = error.response?.statusCode;
      final path = error.requestOptions.path;

      final isPregnancy404 = statusCode == 404 && path.contains('/pregnancy-calculator/my');
      final is504 = statusCode == 504;
      final is401 = statusCode == 401;

      if (is401) {
        // Token expired or invalid — redirect to login but don't clear token
        debugPrint('[401] Session expired. Redirecting to login without clearing token.');
        _navigateToLogin();
      } else if (is504) {
        debugPrint('[504] HANDLED: ${error.requestOptions.uri}');
      } else if (!isPregnancy404) {
        debugPrint('[${statusCode}] ERROR: ${error.requestOptions.uri}');
      }

      return handler.next(error);
    },
  ));

  return dio;
});

/// Navigate to login using the root navigator context.
/// Uses a post-frame callback to avoid calling during a build.
void _navigateToLogin() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = _rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.go('/login');
    }
  });
}

/// Global navigator key — must be set in MaterialApp.
/// Add this to your GoRouter or MaterialApp setup:
///   navigatorKey: navigatorKey,
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Internal alias used by _navigateToLogin
final _rootNavigatorKey = navigatorKey;
