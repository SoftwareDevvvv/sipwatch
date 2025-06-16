# SipWatch Implementation Plan Document

## Project Overview

**App Name:** SipWatch  
**Framework:** Flutter  
**Target Platforms:** Android (minSDK 26, API 34) & iOS (13-16)  
**Bundle ID:** com.SipWatch.SW2905  
**State Management:** GetX  
**Database:** SQLite with Hive for local storage  
**Orientation:** Portrait only  
**Mode:** Offline-first  
**Theme:** Light theme only  
**Language:** English only

## 1. Technical Architecture

### 1.1 Project Structure (Enhanced GetX Architecture)

```
lib/
├── main.dart
├── app/
│   ├── bindings/
│   │   ├── initial_binding.dart
│   │   └── home_binding.dart
│   └── routes/
│       ├── app_pages.dart
│       └── app_routes.dart
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── drink_types.dart
│   │   └── notification_constants.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   ├── date_utils.dart
│   │   └── platform_utils.dart
│   ├── services/
│   │   ├── database_service.dart
│   │   ├── notification_service.dart
│   │   ├── image_service.dart
│   │   ├── storage_service.dart
│   │   └── permission_service.dart
│   └── extensions/
│       ├── date_extensions.dart
│       └── string_extensions.dart
├── data/
│   ├── models/
│   │   ├── drink_entry.dart
│   │   ├── user_profile.dart
│   │   ├── daily_norm.dart
│   │   ├── notification_settings.dart
│   │   └── consumption_stats.dart
│   ├── repositories/
│   │   ├── drink_repository.dart
│   │   ├── user_repository.dart
│   │   ├── settings_repository.dart
│   │   └── stats_repository.dart
│   ├── providers/
│   │   └── local/
│   │       ├── database_provider.dart
│   │       └── hive_provider.dart
│   └── adapters/
│       ├── drink_entry_adapter.dart
│       └── user_profile_adapter.dart
├── features/
│   ├── home/
│   │   ├── controllers/
│   │   │   └── home_controller.dart
│   │   ├── screens/
│   │   │   └── today_screen.dart
│   │   ├── widgets/
│   │   │   ├── consumption_graph.dart
│   │   │   ├── daily_stats_card.dart
│   │   │   ├── add_drink_button.dart
│   │   │   └── drink_list_item.dart
│   │   └── bindings/
│   │       └── home_binding.dart
│   ├── add_fluid/
│   │   ├── controllers/
│   │   │   └── add_fluid_controller.dart
│   │   ├── screens/
│   │   │   └── add_fluid_screen.dart
│   │   ├── widgets/
│   │   │   ├── drink_type_selector.dart
│   │   │   ├── volume_input.dart
│   │   │   ├── photo_capture.dart
│   │   │   └── time_picker.dart
│   │   └── bindings/
│   │       └── add_fluid_binding.dart
│   ├── calendar/
│   │   ├── controllers/
│   │   │   └── calendar_controller.dart
│   │   ├── screens/
│   │   │   └── calendar_screen.dart
│   │   ├── widgets/
│   │   │   ├── calendar_widget.dart
│   │   │   ├── day_consumption_card.dart
│   │   │   └── filter_chips.dart
│   │   └── bindings/
│   │       └── calendar_binding.dart
│   ├── stats/
│   │   ├── controllers/
│   │   │   └── stats_controller.dart
│   │   ├── screens/
│   │   │   └── stats_screen.dart
│   │   ├── widgets/
│   │   │   ├── consumption_chart.dart
│   │   │   ├── weekly_chart.dart
│   │   │   ├── monthly_chart.dart
│   │   │   └── comparison_widget.dart
│   │   └── bindings/
│   │       └── stats_binding.dart
│   └── settings/
│       ├── controllers/
│       │   └── settings_controller.dart
│       ├── screens/
│       │   ├── settings_screen.dart
│       │   ├── personal_info_screen.dart
│       │   ├── notification_settings_screen.dart
│       │   ├── daily_norm_screen.dart
│       │   └── body_fluid_calculator_screen.dart
│       ├── widgets/
│       │   ├── settings_card.dart
│       │   ├── photo_picker.dart
│       │   └── fluid_calculator.dart
│       └── bindings/
│           └── settings_binding.dart
└── shared/
    ├── widgets/
    │   ├── custom_app_bar.dart
    │   ├── loading_indicator.dart
    │   ├── error_widget.dart
    │   ├── confirmation_dialog.dart
    │   └── image_viewer.dart
    └── components/
        ├── bottom_navigation.dart
        └── custom_buttons.dart
```

### 1.2 Database Schema Design

#### Database Solution: **SQLite + Hive Hybrid**

- **SQLite:** For relational data (drinks, consumption history, stats)
- **Hive:** For settings, user preferences, and caching
- **Path Provider:** For managing file storage locations

#### SQLite Tables:

**1. users**

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    profile_photo_path TEXT,
    gender TEXT CHECK(gender IN ('male', 'female')) NOT NULL,
    weight REAL NOT NULL,
    activity_level TEXT CHECK(activity_level IN ('light', 'mild', 'moderate', 'heavy')) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**2. daily_norms**

```sql
CREATE TABLE daily_norms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    water_ml INTEGER NOT NULL DEFAULT 2000,
    coffee_ml INTEGER NOT NULL DEFAULT 400,
    alcohol_ml INTEGER NOT NULL DEFAULT 0,
    calculated_water_ml INTEGER, -- From body fluid calculator
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**3. drink_entries**

```sql
CREATE TABLE drink_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    drink_type TEXT CHECK(drink_type IN ('water', 'coffee', 'alcohol')) NOT NULL,
    name TEXT NOT NULL,
    volume_ml INTEGER NOT NULL,
    caffeine_mg INTEGER DEFAULT 0,
    alcohol_percentage REAL DEFAULT 0,
    photo_path TEXT,
    consumption_time DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**4. notification_settings**

```sql
CREATE TABLE notification_settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    daily_notification BOOLEAN DEFAULT 1,
    morning_tips BOOLEAN DEFAULT 0,
    water_warning BOOLEAN DEFAULT 0,
    coffee_warning BOOLEAN DEFAULT 0,
    alcohol_warning BOOLEAN DEFAULT 0,
    reminder_intervals TEXT, -- JSON array of time intervals
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**5. consumption_history**

```sql
CREATE TABLE consumption_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    date DATE NOT NULL,
    total_water_ml INTEGER DEFAULT 0,
    total_coffee_ml INTEGER DEFAULT 0,
    total_alcohol_ml INTEGER DEFAULT 0,
    total_caffeine_mg INTEGER DEFAULT 0,
    water_percentage REAL DEFAULT 0,
    coffee_percentage REAL DEFAULT 0,
    alcohol_percentage REAL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE(user_id, date)
);
```

#### Hive Boxes:

- **user_settings:** User preferences and app settings
- **image_cache:** Local image storage metadata
- **drink_cache:** Temporary drink data for quick access

### 1.3 Dependencies Required

#### Core Dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  get: ^4.6.6

  # Database & Storage
  sqflite: ^2.3.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.1
  path: ^1.8.3

  # Image Handling
  image_picker: ^1.0.4
  image: ^4.1.3

  # Notifications
  flutter_local_notifications: ^16.1.0
  timezone: ^0.9.2
  permission_handler: ^11.0.1

  # UI & Charts
  fl_chart: ^0.65.0
  flutter_svg: ^2.1.0
  cupertino_icons: ^1.0.8

  # Utilities
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
  flutter_lints: ^4.0.0
```

## 2. Platform-Specific Configurations

### 2.1 Android Configuration

#### android/app/build.gradle:

```gradle
android {
    compileSdkVersion 34
    ndkVersion "25.1.8937393"

    defaultConfig {
        applicationId "com.SipWatch.SW2905"
        minSdkVersion 26
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }
}
```

#### android/app/src/main/AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

### 2.2 iOS Configuration

#### ios/Runner/Info.plist:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos of your drinks</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select drink photos</string>
<key>CFBundleIdentifier</key>
<string>com.SipWatch.SW2905</string>
<key>UIRequiredDeviceCapabilities</key>
<array>
    <string>arm64</string>
</array>
```

## 3. Core Features Implementation

### 3.1 Image Capture & Storage

**Multi-Platform Image Service:**

```dart
class ImageService extends GetxService {
  static ImageService get to => Get.find();

  Future<String?> captureImage({ImageSource source = ImageSource.camera}) async {
    try {
      // Platform-specific configurations
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageLocally(image);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
    return null;
  }

  Future<String> _saveImageLocally(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final localPath = '${directory.path}/images/$fileName';

    await Directory('${directory.path}/images').create(recursive: true);
    await image.saveTo(localPath);

    return localPath;
  }
}
```

### 3.2 Notification Service

**Cross-Platform Notification Implementation:**

```dart
class NotificationService extends GetxService {
  static NotificationService get to => Get.find();
  late FlutterLocalNotificationsPlugin _notifications;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
    await _requestPermissions();
  }

  Future<void> _initializeNotifications() async {
    _notifications = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> scheduleHydrationReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hydration_reminders',
          'Hydration Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
```

### 3.3 Database Service

**Unified Database Management:**

```dart
class DatabaseService extends GetxService {
  static DatabaseService get to => Get.find();
  late Database _database;
  late Box _settingsBox;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeHive();
    await _initializeSQLite();
  }

  Future<void> _initializeSQLite() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      '$path/sipwatch.db',
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Execute all CREATE TABLE statements
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        profile_photo_path TEXT,
        gender TEXT CHECK(gender IN ('male', 'female')) NOT NULL,
        weight REAL NOT NULL,
        activity_level TEXT CHECK(activity_level IN ('light', 'mild', 'moderate', 'heavy')) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Additional tables...
  }
}
```

## 4. GetX Controllers Architecture

### 4.1 Home Controller

```dart
class HomeController extends GetxController {
  final DrinkRepository _drinkRepository = Get.find();
  final UserRepository _userRepository = Get.find();

  // Observables
  final RxList<DrinkEntry> todayDrinks = <DrinkEntry>[].obs;
  final Rx<DailyStats> dailyStats = DailyStats.empty().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTodayData();
  }

  Future<void> loadTodayData() async {
    isLoading.value = true;
    try {
      final today = DateTime.now();
      todayDrinks.value = await _drinkRepository.getDrinksByDate(today);
      dailyStats.value = await _calculateDailyStats(todayDrinks);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load today\'s data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDrink(DrinkEntry drink) async {
    try {
      await _drinkRepository.insertDrink(drink);
      await loadTodayData(); // Refresh data
      Get.snackbar('Success', 'Drink added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add drink');
    }
  }
}
```

## 5. Error Handling & Edge Cases

### 5.1 Platform-Specific Error Handling

- **Camera Access:** Handle permission denials gracefully with user-friendly messages
- **Storage:** Local storage with proper error handling for disk space issues
- **Database:** Transaction rollbacks and data integrity checks
- **Memory:** Efficient image caching and automatic cleanup

### 5.2 Data Validation

- Input sanitization for all user inputs
- Volume limits (max 5000ml per entry)
- Date range validations (no future dates)
- Image size and format validation (max 5MB, JPG/PNG only)

### 5.3 Performance Considerations

- Lazy loading for large datasets
- Image compression before storage (max 1024x1024)
- Database query optimization with proper indexing
- Memory-efficient chart rendering with data pagination

## 6. Testing Strategy

### 6.1 Unit Tests

- Controller logic testing
- Repository pattern testing
- Utility function testing
- Database operation testing

### 6.2 Integration Tests

- Database integration
- Image capture flow
- Notification scheduling
- Cross-platform functionality

### 6.3 Widget Tests

- UI component testing
- Form validation testing
- Navigation testing

## 7. Implementation Phases

### Phase 1: Foundation (Week 1)

- Project structure setup with GetX architecture
- Database schema implementation (SQLite + Hive)
- Core services setup (Database, Storage, Image)
- Basic navigation with GetX routing

### Phase 2: Core Features (Week 2)

- User profile management
- Basic drink entry system
- Local image capture and storage
- Simple consumption tracking

### Phase 3: Data & Analytics (Week 3)

- Statistics calculation and display
- Calendar view implementation
- Chart integration with fl_chart
- Data persistence and retrieval

### Phase 4: Settings & Notifications (Week 4)

- Settings screens implementation
- Local notification system
- Daily norm calculations
- User preferences management

### Phase 5: Polish & Testing (Week 5)

- UI/UX refinements
- Error handling implementation
- Performance optimization
- Cross-platform testing

## 8. Deployment Considerations

### 8.1 Android

- ProGuard configuration for release builds
- App signing setup for Google Play Store
- Local storage optimization for Android file system

### 8.2 iOS

- Code signing and provisioning profiles
- App Store guidelines compliance
- iOS-specific storage and permission handling

---

**Next Steps:**

1. Review and approve this simplified implementation plan
2. Set up the offline-first project structure
3. Begin Phase 1 implementation
4. Focus on core offline functionality

This simplified plan ensures a robust, offline-first Flutter application that works seamlessly on both Android and iOS platforms with GetX state management, focusing on essential features without unnecessary complexity.
