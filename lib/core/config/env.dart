class Env {
  static const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://10.0.2.2:8000');
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');
}

