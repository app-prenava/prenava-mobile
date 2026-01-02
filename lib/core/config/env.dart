class Env {
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://prenava.up.railway.app/api',
  );

  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const String logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');
}