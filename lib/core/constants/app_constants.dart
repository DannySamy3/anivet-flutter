class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000/api';
  static const int apiTimeout = 30000; // 30 seconds
  
  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'user_data';
  static const String storageKeyThemeMode = 'theme_mode';
  static const String storageKeyLocale = 'locale';
  
  // Query Cache Configuration
  static const Duration defaultStaleTime = Duration(minutes: 5);
  static const Duration defaultCacheTime = Duration(minutes: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Image Upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
}
