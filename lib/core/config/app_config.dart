class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://alnadha.net/api/v1',
  );

  static const String driverApiBaseUrl = String.fromEnvironment(
    'DRIVER_API_BASE_URL',
    defaultValue: 'https://alnadha.net/api/v1/delivery/driver',
  );
}
