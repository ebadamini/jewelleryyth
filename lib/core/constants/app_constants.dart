class AppConstants {
  const AppConstants._();

  static const String apiBaseUrl = String.fromEnvironment(
    'http://91.108.111.102/api',
    defaultValue: 'http://91.108.111.102/api',
  );

  static const bool useMockData = false;

  // Timeout settings
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
}