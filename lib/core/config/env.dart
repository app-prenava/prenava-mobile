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
    defaultValue: '25931493669-61q4u0f7h4h3i3b6g060j7j2o3h69v9b.apps.googleusercontent.com',
  );

  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '25931493669-1v2b3n4m5k6j7h8g9f0d1s2a3p4o5i6u.apps.googleusercontent.com',
  );

  static const String env = String.fromEnvironment('ENV', defaultValue: 'prod');
  static const String logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'info');
}
