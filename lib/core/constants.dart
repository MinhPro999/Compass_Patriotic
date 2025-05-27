/// Constants file để quản lý các giá trị hard-coded
class AppConstants {
  // Colors
  static const int primaryRedColor = 0xAEBE0A0A;
  static const int statusBarColor = 0xDEBE0A0A;
  static const int yellowColor = 0xFFFDFC99;
  static const int darkYellowColor = 0xFFC7C400;
  static const int whiteColor = 0xFFFFFFFF;
  static const int blackColor = 0xFF000000;
  static const int redTextColor = 0xFFed1c24;

  // Sizes
  static const double compassSize = 400.0;
  static const double infoBoxWidth = 400.0;
  static const double infoBoxHeight = 190.0;
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 16.0;

  // Text Sizes
  static const double titleFontSize = 22.0;
  static const double subtitleFontSize = 20.0;
  static const double bodyFontSize = 16.0;
  static const double largeFontSize = 17.0;

  // Compass Settings
  static const double compassSmoothingAlpha = 0.33;

  // Asset Paths
  static const String backgroundImage = 'assets/images/background.jpg';
  static const String screenBackground = 'assets/images/screen_dang.jpg';
  static const String compassImage = 'assets/images/compass.png';
  static const String compassOverlay = 'assets/images/khung_compass.png';
  static const String compass8Overlay = 'assets/images/khung_8.png';
  static const String normalCompassImage = 'assets/images/normal_compass.JPG';
  static const String directionsImage = 'assets/images/24_directions.JPG';
  static const String appIcon = 'assets/images/icon_app_mini.png';

  // Font Family
  static const String fontFamily = 'opensans';

  // Error Messages
  static const String noSensorData = 'Không có dữ liệu cảm biến!';
  static const String sensorError = 'Lỗi khi đọc dữ liệu cảm biến';
  static const String noSensorAvailable = 'Không có dữ liệu cảm biến';
  static const String missingInfoError = 'Thông tin bị thiếu!';
  static const String missingInfoMessage =
      'Bạn cần lựa chọn giới tính và nhập đầy đủ năm sinh ở ngay phía trên trước khi sử dụng La Bàn này.';
  static const String agreeButton = 'ĐỒNG Ý';
  static const String insufficientDataMessage =
      'Chưa có đủ dữ liệu để tính toán.';

  // Titles
  static const String chooseCompassTitle = 'Chọn La Bàn';
  static const String basicCompassTitle = 'La bàn cơ bản';
  static const String ageCompassTitle = 'La bàn theo tuổi';
  static const String basicCompassScreenTitle = 'La Bàn Cơ Bản';

  // Gender Mapping
  static const Map<String, String> genderMapping = {
    'Nam': 'male',
    'Nữ': 'female'
  };

  // JSON File Mapping
  static const Map<int, String> jsonFileMapping = {
    1: 'e1_data.json',
    2: 'w2_data.json',
    3: 'e3_data.json',
    4: 'e4_data.json',
    6: 'w6_data.json',
    7: 'w7_data.json',
    8: 'w8_data.json',
    9: 'e9_data.json',
  };

  // Default Values
  static const String defaultJsonFile = 'e1_data.json';
  static const int maxYearLength = 4;
  static const int minSdkVersion = 21;
  static const int targetSdkVersion = 34;

  // AdMob Configuration
  static const String admobAppId = 'ca-app-pub-9304712998147652~6524476555';

  // Production Ad Unit IDs
  static const String bannerAdUnitId = 'ca-app-pub-9304712998147652/5034133623';
  static const String interstitialAdUnitId =
      'ca-app-pub-9304712998147652/1837124648';

  // AdMob Settings
  static const int adLoadTimeoutSeconds = 10;

  // Facebook SDK Configuration
  static const String facebookAppId = '1010457991232883';
  static const String facebookClientToken = 'fb1010457991232883';
  static const String facebookLoginProtocolScheme = 'fb1010457991232883';

  // Deep Link Configuration
  static const String deepLinkHost = 'compassapp.hellovietnam.com';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.hellovietnam.compassapp_vn';
}

/// Direction constants
class DirectionConstants {
  static const String north = 'Bắc';
  static const String northeast = 'Đông Bắc';
  static const String east = 'Đông';
  static const String southeast = 'Đông Nam';
  static const String south = 'Nam';
  static const String southwest = 'Tây Nam';
  static const String west = 'Tây';
  static const String northwest = 'Tây Bắc';
  static const String unknown = 'Không xác định';
}

/// Opacity values
class OpacityConstants {
  static const double backgroundOverlay = 0.1;
  static const double containerBackground = 0.8;
  static const double shadowOpacity = 0.2;
  static const double infoBoxBackground = 0.68686868;
  static const double infoBoxShadow = 0.268268;
}
