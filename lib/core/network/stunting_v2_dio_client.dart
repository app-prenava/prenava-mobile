import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';

final stuntingV2DioProvider = Provider<Dio>((ref) {
  if (!Env.useStuntingV2Local) {
    throw StateError(
      'Stunting V2 local client is disabled. Start Flutter with '
      '--dart-define=USE_STUNTING_V2_LOCAL=true.',
    );
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: Env.stuntingV2LocalApiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: const {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (value) => debugPrint('[STUNTING_V2_LOCAL] $value'),
    ),
  );
  return dio;
});
