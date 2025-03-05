class EnvConfig {
  static const String environment =
      String.fromEnvironment("ENV", defaultValue: 'DEBUG');

  static const String apiUrl =
      String.fromEnvironment('API_URL', defaultValue: "");
  static const bool loggingEnabled =
      bool.fromEnvironment("LOGGING_ENABLED", defaultValue: true);

  static bool get isProduction => environment == 'PRODUCTION';
  static bool get isDebugProd => environment == 'DEBUG_PROD';
}
