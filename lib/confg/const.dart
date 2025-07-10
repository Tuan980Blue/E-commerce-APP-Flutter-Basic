// Enum để định nghĩa các chế độ hiển thị sản phẩm
enum ViewMode {
  list,
  grid,
  table,
}

class AppConstants {
  // App Info
  static const String appName = 'List Product';
  static const String appVersion = '1.0.0';
  
  // Assets Paths
  static const String categoryListPath = 'assets/files/categorylist.json';
  static const String productListPath = 'assets/files/productlist.json';
  static const String imagesPath = 'assets/images/';
  
  // UI Constants
  static const double cardElevation = 3.0;
  static const double cardMargin = 8.0;
  static const double imageSize = 48.0;
  static const double gridSpacing = 12.0;
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;
  
  // Padding
  static const double defaultPadding = 12.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 16.0;
  
  // Text Styles
  static const double titleFontSize = 18.0;
  static const double subtitleFontSize = 14.0;
  
  // Colors
  static const int primaryColorValue = 0xFF2196F3; // Blue
  static const int accentColorValue = 0xFFFF5722; // Orange
  static const int errorColorValue = 0xFFF44336; // Red
  static const int successColorValue = 0xFF4CAF50; // Green
}
