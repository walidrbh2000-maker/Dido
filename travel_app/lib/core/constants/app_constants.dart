class AppConstants {
  const AppConstants._();

  static const String baseUrl = 'http://localhost/api/v1';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int defaultPageSize = 15;
  static const int splashDurationSeconds = 2;
  static const int carouselAutoScrollDuration = 4000;
  static const int debounceMilliseconds = 500;
}
