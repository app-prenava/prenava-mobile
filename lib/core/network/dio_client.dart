import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env.dart';
import '../../shared/services/secure_store.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
final appDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBase,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final path = options.path;
        final isAuthEndpoint =
            path.contains('/auth/login') ||
            path.contains('/auth/register') ||
            path.contains('/auth/forgot-password') ||
            path.contains('/auth/verify-email') ||
            path.contains('/auth/resend-verification') ||
            path.contains('/auth/google');

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
        final responseData = error.response?.data;

        final isPregnancy404 =
            statusCode == 404 && path.contains('/pregnancy-calculator/my');
        final is504 = statusCode == 504;
        final is401 = statusCode == 401;

        if (is401) {
          debugPrint(
            '[401] Unauthorized response received at ${error.requestOptions.uri}',
          );
          final isAuthEndpoint = path.contains('/auth/login') ||
              path.contains('/auth/register') ||
              path.contains('/auth/forgot-password') ||
              path.contains('/auth/verify-email') ||
              path.contains('/auth/resend-verification') ||
              path.contains('/auth/google');
              
          if (!isAuthEndpoint) {
            Future.microtask(() {
              ref.read(authNotifierProvider.notifier).forceLogout();
              if (navigatorKey.currentContext != null) {
                navigatorKey.currentContext!.go('/login');
              }
            });
          }
        } else if (is504) {
          debugPrint('[504] HANDLED: ${error.requestOptions.uri}');
        } else if (!isPregnancy404) {
          debugPrint('[$statusCode] ERROR: ${error.requestOptions.uri}');
          if (responseData != null) {
            debugPrint('[$statusCode] BODY: $responseData');
          }
        }

        return handler.next(error);
      },
    ),
  );

  return dio;
});

/// Global navigator key — must be set in MaterialApp.
/// Add this to your GoRouter or MaterialApp setup:
///   navigatorKey: navigatorKey,
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
