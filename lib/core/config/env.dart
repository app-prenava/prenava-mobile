class Env {
  static const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://192.168.0.153:8000/api');
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const logLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'debug');
}

