class Env {
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://prenavabe.cloud/api',
  );

  // Official Prenava Google OAuth Client IDs (Project: 25931493669)
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '25931493669-vtlgpreroo33hmqvvv0hhhpcnarmn1u6.apps.googleusercontent.com',
  );

  static const String googleAndroidClientId = String.fromEnvironment(
    'GOOGLE_ANDROID_CLIENT_ID',
    defaultValue: '25931493669-s9up4alhon8p2rj1trb7q0p5imh7hbso.apps.googleusercontent.com',
  );

  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '25931493669-879hmlbggmtiojjavpnvi840bd10601e.apps.googleusercontent.com',
  );

  static const String env = String.fromEnvironment('ENV', defaultValue: 'prod');
  static const String logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'info');
}
