import 'package:flutter/foundation.dart';

class Env {
  // Production URL (backend live di cloud)
  static const String prodApiBase = 'https://prenavabe.cloud/api';

  // Local Development URL (laptop backend)
  static const String localApiBase = 'http://192.168.110.64:8000/api';
  static const String localHostApiBase = 'http://localhost:8000/api';

  // Otomatis mengarah ke prodApiBase saat mode release (Play Store APK & Live PWA).
  // Saat Web lokal: jika diakses via IP Wi-Fi (iPhone), otomatis arahkan API ke IP laptop di port 8000.
  // Dapat dioverride lewat --dart-define=API_BASE=...
  static String get apiBase {
    const defined = String.fromEnvironment('API_BASE');
    if (defined.isNotEmpty) return defined;
    if (kReleaseMode) return prodApiBase;
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.isNotEmpty && host != 'localhost' && host != '127.0.0.1') {
        if (host.contains('prenava.cloud')) {
          return prodApiBase;
        }
        return 'http://$host:8000/api';
      }
      return localHostApiBase;
    }
    return localApiBase;
  }

  // Opt-in only: direct access to the frozen Stunting V2 local test service.
  // A normal/release build stays on the Laravel-backed flow above.
  static const bool useStuntingV2Local = bool.fromEnvironment(
    'USE_STUNTING_V2_LOCAL',
    defaultValue: false,
  );
  static const String stuntingV2LocalApiBase = String.fromEnvironment(
    'STUNTING_V2_API_BASE',
    defaultValue: 'http://10.0.2.2:8001',
  );

  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const String logLevel =
      String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');

  // Google OAuth 2.0 Client IDs (Official Prenava Project)
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '25931493669-vtlgpreroo33hmqvvv0hhhpcnarmn1u6.apps.googleusercontent.com',
  );
  static const String googleAndroidClientId = String.fromEnvironment(
    'GOOGLE_ANDROID_CLIENT_ID',
    defaultValue:
        '25931493669-s9up4alhon8p2rj1trb7q0p5imh7hbso.apps.googleusercontent.com',
  );
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue:
        '25931493669-879hmlbggmtiojjavpnvi840bd10601e.apps.googleusercontent.com',
  );
}
