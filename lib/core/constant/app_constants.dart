class AppConstants {
  // Storage Keys
  static const String keyApiKey = 'api_key';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyAccessToken = 'access_token';
  static const String keyTokenExpiry = 'access_token_expiry';
  
  // API Endpoints
  static const String endpointGetToken = '/v1/get_access_token';
  static const String endpointDeviceList = '/v1/get_list_of_devices';
  static const String endpointDeviceState = '/v1/get_device_state';
  static const String endpointSendCommand = '/v1/send_command';
  
  // Headers
  static const String headerApiKey = 'x-api-key';
  static const String headerAuth = 'Authorization';
  static const String headerContentType = 'Content-Type';
  
  // Fan Speeds
  static const int minSpeed = 1;
  static const int maxSpeed = 6;
  
  // Timer Options (in hours)
  static const List<int> timerOptions = [0, 1, 2, 3, 6];
  
  // Brightness Range
  static const int minBrightness = 10;
  static const int maxBrightness = 100;
  
  // Color Modes
  static const String colorWarm = 'warm';
  static const String colorCool = 'cool';
  static const String colorDaylight = 'daylight';
  
  // Device Series
  static const String seriesI1 = 'I1';
  static const String seriesS1 = 'S1';
  static const String seriesM1 = 'M1';
}