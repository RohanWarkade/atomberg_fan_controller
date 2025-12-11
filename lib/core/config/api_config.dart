class ApiConfig {
  static const String baseUrl = 'https://api.developer.atomberg-iot.com';
  static const String version = 'v1';
  
  static const Duration tokenExpiry = Duration(hours: 24);
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}