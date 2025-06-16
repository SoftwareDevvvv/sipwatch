class AppConstants {
  // App Information
  static const String appName = 'SipWatch';
  static const String appVersion = '1.0.0';
  static const String bundleId = 'com.SipWatch.SW2905';

  // Database Configuration
  static const String databaseName = 'sipwatch.db';
  static const int databaseVersion = 1;

  // Hive Box Names
  static const String userSettingsBox = 'user_settings';
  static const String imageCacheBox = 'image_cache';
  static const String drinkCacheBox = 'drink_cache';

  // Image Configuration
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
  static const int imageQuality = 85;
  static const int maxImageSizeMB = 5;

  // Volume Limits
  static const int minVolumeML = 1;
  static const int maxVolumeML = 5000;

  // Default Daily Norms (in ml)
  static const int defaultWaterML = 2000;
  static const int defaultCoffeeML = 400;
  static const int defaultAlcoholML = 0;

  // Fluid Calculation Constants
  static const double maleBaseRequirement = 35.0; // ml per kg
  static const double femaleBaseRequirement = 31.0; // ml per kg

  // Activity Multipliers
  static const Map<String, double> activityMultipliers = {
    'light': 1.0,
    'mild': 1.2,
    'moderate': 1.4,
    'heavy': 1.6,
  };

  // Notification IDs
  static const int dailyReminderNotificationId = 1000;
  static const int waterWarningNotificationId = 1001;
  static const int coffeeWarningNotificationId = 1002;
  static const int alcoholWarningNotificationId = 1003;
}
