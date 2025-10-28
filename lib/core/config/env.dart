class Env {
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://192.168.1.16:8000/api',
  );

  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const String logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');
}

