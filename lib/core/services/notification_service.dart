import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/controllers/settings_controller.dart';

class NotificationService extends GetxController {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late SharedPreferences _prefs;

  // Notification IDs
  static const int morningTipNotificationId = 100;
  static const int waterWarningNotificationId = 200;
  static const int coffeeWarningNotificationId = 300;
  static const int alcoholWarningNotificationId = 400;
  // Track if warnings have been shown today (to prevent spam)
  final RxBool _waterWarningShownToday = false.obs;
  final RxBool _coffeeWarningShownToday = false.obs;
  final RxBool _alcoholWarningShownToday = false.obs;
  final RxBool _isMidnightTimerActive = false.obs;

  // Getters for UI access
  RxBool get waterWarningShownToday => _waterWarningShownToday;
  RxBool get coffeeWarningShownToday => _coffeeWarningShownToday;
  RxBool get alcoholWarningShownToday => _alcoholWarningShownToday;
  RxBool get isMidnightTimerActive => _isMidnightTimerActive;

  // Timer for daily reset
  Timer? _dailyResetTimer;

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
  }

  /// Initialize the notification service
  Future<void> initializeNotifications() async {
    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Set local timezone with better detection
      try {
        // Common timezone mappings for different regions
        final String systemTimeZone = DateTime.now().timeZoneName;
        String? locationName;

        // Try to map common timezone abbreviations to full names
        switch (systemTimeZone) {
          case 'GMT':
          case 'UTC':
            locationName = 'UTC';
            break;
          case 'EST':
          case 'EDT':
            locationName = 'America/New_York';
            break;
          case 'PST':
          case 'PDT':
            locationName = 'America/Los_Angeles';
            break;
          case 'CST':
          case 'CDT':
            locationName = 'America/Chicago';
            break;
          case 'MST':
          case 'MDT':
            locationName = 'America/Denver';
            break;
          default:
            // Try to use the system timezone name directly
            try {
              final location = tz.getLocation(systemTimeZone);
              tz.setLocalLocation(location);
              print('NotificationService: Timezone set to $systemTimeZone');
              locationName = null; // Already set
            } catch (e) {
              // Fall back to UTC if specific timezone fails
              locationName = 'UTC';
              print(
                  'NotificationService: Unknown timezone $systemTimeZone, using UTC');
            }
        }

        if (locationName != null) {
          final location = tz.getLocation(locationName);
          tz.setLocalLocation(location);
          print('NotificationService: Timezone set to $locationName');
        }
      } catch (e) {
        print('NotificationService: Timezone setup failed, using UTC: $e');
        tz.setLocalLocation(tz.UTC);
      }

      // Android initialization settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Combined initialization settings
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Initialize the plugin
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channels for Android
      await _createNotificationChannels();

      // Request permissions
      await _requestPermissions();

      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Check if we need to reset warnings based on date change
      await _loadLastResetDate();

      // Set up daily reset timer
      _startMidnightTimer();

      // Schedule morning tips if enabled
      await scheduleDailyMorningTip();

      print('NotificationService: Initialized successfully');
    } catch (e) {
      print('NotificationService: Initialization failed - $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Request notification permission for Android 13+
      final status = await Permission.notification.request();
      print('NotificationService: Android permission status - $status');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // Request iOS permissions
      final bool? result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      print('NotificationService: iOS permission granted - $result');
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print(
        'NotificationService: Notification tapped - ${notificationResponse.payload}');
    // TODO: Handle navigation based on notification type
  }

  /// Schedule daily morning tip notification
  Future<void> scheduleDailyMorningTip() async {
    try {
      final settingsController = Get.find<SettingsController>();

      // Check if daily notifications and morning tips are enabled
      if (!settingsController.dailyNotification.value ||
          !settingsController.morningTips.value) {
        await cancelMorningTip();
        print('NotificationService: Morning tips disabled in settings');
        return;
      }

      // Cancel any existing morning tip notifications first
      await cancelMorningTip();

      // Schedule for 8:00 AM daily
      final scheduledDate = _nextInstanceOf8AM();
      print('NotificationService: Scheduling morning tip for $scheduledDate');
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        morningTipNotificationId,
        'Good Morning! 🌅',
        _getRandomMorningTip(),
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'morning_tips',
            'Morning Tips',
            channelDescription: 'Daily morning hydration tips',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('NotificationService: Morning tip scheduled for 8:00 AM daily');
    } catch (e) {
      print('NotificationService: Failed to schedule morning tip - $e');
    }
  }

  /// Cancel morning tip notification
  Future<void> cancelMorningTip() async {
    await _flutterLocalNotificationsPlugin.cancel(morningTipNotificationId);
    print('NotificationService: Morning tip cancelled');
  }

  /// Get next 8 AM instance
  tz.TZDateTime _nextInstanceOf8AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('NotificationService: Current time: $now');
    print('NotificationService: Next 8 AM scheduled for: $scheduledDate');
    print(
        'NotificationService: Time until notification: ${scheduledDate.difference(now)}');

    return scheduledDate;
  }

  /// Get a random morning tip message
  String _getRandomMorningTip() {
    final tips = [
      "Start your day with a glass of water! 💧",
      "Did you know coffee counts toward your daily fluid intake?",
      "Moderate alcohol consumption - your body will thank you! 🌟",
      "Hydration is key to feeling energized throughout the day!",
      "Your body is 60% water - keep it topped up! 🚰",
      "Green tea is a great hydrating alternative to coffee! 🍵",
      "Remember: if you feel thirsty, you're already dehydrated!",
      "Fruits like watermelon contribute to your daily hydration! 🍉",
      "Drink water first thing when you wake up! ☀️",
      "Herbal teas count towards your fluid intake! 🌿",
      "Coconut water is nature's sports drink! 🥥",
      "Add lemon to your water for extra flavor and vitamin C! 🍋",
      "Room temperature water is easier for your body to absorb! 🌡️",
      "Cucumber water is refreshing and hydrating! 🥒",
      "Your brain is 75% water - keep it hydrated for better focus! 🧠",
      "Drink a glass of water before each meal! 🍽️",
      "Sparkling water counts towards your daily intake too! ✨",
      "Keep a water bottle with you throughout the day! 🍼",
      "Eat water-rich foods like oranges and lettuce! 🥬",
      "Cold water can boost your metabolism slightly! ❄️",
      "Drink extra water when you're sick! 🤒",
      "Replace one coffee with water today! ☕➡️💧",
      "Your skin will thank you for staying hydrated! ✨",
    ];

    return tips[DateTime.now().millisecond % tips.length];
  }

  /// Check and trigger water warning notification
  Future<void> checkWaterWarning(int currentAmount) async {
    final settingsController = Get.find<SettingsController>();

    // Check if notifications and water warnings are enabled
    if (!settingsController.dailyNotification.value ||
        !settingsController.waterWarning.value ||
        _waterWarningShownToday.value) {
      return;
    }

    // Check if water goal is exceeded
    if (currentAmount > settingsController.waterDailyGoal.value) {
      await _showWarningNotification(
        waterWarningNotificationId,
        'Water Goal Achieved! 💧',
        'Congratulations! You\'ve exceeded your daily water goal of ${settingsController.waterDailyGoal.value}ml. Great hydration!',
        'water_warnings',
        'Water Goal Notifications',
        'Notifications when water goals are achieved',
      );

      _waterWarningShownToday.value = true;
      print('NotificationService: Water warning triggered');
    }
  }

  /// Check and trigger coffee warning notification
  Future<void> checkCoffeeWarning(int currentAmount) async {
    final settingsController = Get.find<SettingsController>();

    // Check if notifications and coffee warnings are enabled
    if (!settingsController.dailyNotification.value ||
        !settingsController.coffeeWarning.value ||
        _coffeeWarningShownToday.value) {
      return;
    }

    // Check if coffee limit is exceeded
    if (currentAmount > settingsController.coffeeDailyLimit.value) {
      await _showWarningNotification(
        coffeeWarningNotificationId,
        'Coffee Limit Exceeded ☕',
        'You\'ve exceeded your daily coffee limit of ${settingsController.coffeeDailyLimit.value}ml. Consider switching to water!',
        'coffee_warnings',
        'Coffee Limit Notifications',
        'Notifications when coffee limits are exceeded',
      );

      _coffeeWarningShownToday.value = true;
      print('NotificationService: Coffee warning triggered');
    }
  }

  /// Check and trigger alcohol warning notification
  Future<void> checkAlcoholWarning(int currentAmount) async {
    final settingsController = Get.find<SettingsController>();

    // Check if notifications and alcohol warnings are enabled
    if (!settingsController.dailyNotification.value ||
        !settingsController.alcoholWarning.value ||
        _alcoholWarningShownToday.value) {
      return;
    }

    // Check if alcohol limit is exceeded
    if (currentAmount > settingsController.alcoholDailyLimit.value) {
      await _showWarningNotification(
        alcoholWarningNotificationId,
        'Alcohol Limit Reached 🚫🍺',
        'You\'ve reached your alcohol limit of ${settingsController.alcoholDailyLimit.value}ml for today. Stay hydrated with water!',
        'alcohol_warnings',
        'Alcohol Limit Notifications',
        'Notifications when alcohol limits are exceeded',
      );

      _alcoholWarningShownToday.value = true;
      print('NotificationService: Alcohol warning triggered');
    }
  }

  /// Show a warning notification
  Future<void> _showWarningNotification(
    int id,
    String title,
    String body,
    String channelId,
    String channelName,
    String channelDescription,
  ) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_notification',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      print('NotificationService: Failed to show warning notification - $e');
    }
  }

  /// Reset daily warning flags (call at midnight)
  void resetDailyWarnings() {
    _waterWarningShownToday.value = false;
    _coffeeWarningShownToday.value = false;
    _alcoholWarningShownToday.value = false;

    // Save the reset date
    _saveLastResetDate();

    print('NotificationService: Daily warning flags reset');
  }

  /// Start the midnight timer for daily reset
  void _startMidnightTimer() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    print(
        'NotificationService: Starting midnight timer - reset in ${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m');

    Timer(timeUntilMidnight, () {
      resetDailyWarnings();
      _startMidnightTimer(); // Reschedule for next day
    });

    _isMidnightTimerActive.value = true;
  }

  /// Load the last reset date from preferences
  Future<void> _loadLastResetDate() async {
    try {
      final lastResetDateString = _prefs.getString('last_warning_reset_date');
      if (lastResetDateString != null) {
        final lastResetDate = DateTime.parse(lastResetDateString);
        final today = DateTime.now();

        // If last reset was not today, reset the warnings
        if (!_isSameDay(lastResetDate, today)) {
          resetDailyWarnings();
        }
      }
    } catch (e) {
      print('NotificationService: Error loading last reset date - $e');
    }
  }

  /// Save the current date as last reset date
  Future<void> _saveLastResetDate() async {
    try {
      await _prefs.setString(
          'last_warning_reset_date', DateTime.now().toIso8601String());
    } catch (e) {
      print('NotificationService: Error saving last reset date - $e');
    }
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Clean up resources
  @override
  void onClose() {
    _dailyResetTimer?.cancel();
    super.onClose();
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('NotificationService: All notifications cancelled');
  }

  /// Update notification settings when user changes preferences
  Future<void> updateNotificationSettings() async {
    // Reschedule morning tips based on current settings
    await scheduleDailyMorningTip();

    print('NotificationService: Settings updated');
  }

  /// Show a test notification (for debugging purposes)
  Future<void> showTestNotification(String title, String body) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        999, // Test notification ID
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_notifications',
            'Test Notifications',
            channelDescription: 'Test notifications for debugging',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      print('NotificationService: Test notification sent');
    } catch (e) {
      print('NotificationService: Failed to show test notification - $e');
    }
  }

  /// Show immediate morning tip (for testing)
  Future<void> showTestMorningTip() async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        998, // Test morning tip ID
        'Test Morning Tip 🌅',
        _getRandomMorningTip(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'morning_tips',
            'Morning Tips',
            channelDescription: 'Daily morning hydration tips',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      print('NotificationService: Test morning tip shown immediately');
    } catch (e) {
      print('NotificationService: Failed to show test morning tip - $e');
    }
  }

  /// Schedule a test morning tip in 5 seconds (for testing)
  Future<void> scheduleTestMorningTipIn5Seconds() async {
    try {
      // Cancel any existing test notification first
      await _flutterLocalNotificationsPlugin.cancel(997);

      // Schedule for 5 seconds from now
      final tz.TZDateTime scheduledDate =
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

      print(
          'NotificationService: Scheduling test morning tip for $scheduledDate (in 5 seconds)');

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        997, // Test scheduled notification ID
        'Test Scheduled Morning Tip 🌅',
        _getRandomMorningTip(),
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'morning_tips',
            'Morning Tips',
            channelDescription: 'Daily morning hydration tips',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print(
          'NotificationService: Test morning tip scheduled for 5 seconds from now');
    } catch (e) {
      print('NotificationService: Failed to schedule test morning tip - $e');
    }
  }

  /// Get pending notifications (for debugging)
  Future<void> checkPendingNotifications() async {
    try {
      final List<PendingNotificationRequest> pendingNotifications =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

      print(
          'NotificationService: Found ${pendingNotifications.length} pending notifications:');
      for (final notification in pendingNotifications) {
        print(
            '  - ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
      }
    } catch (e) {
      print('NotificationService: Failed to check pending notifications - $e');
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Morning tips channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'morning_tips',
            'Morning Tips',
            description: 'Daily morning hydration tips',
            importance: Importance.defaultImportance,
          ),
        );

        // Test notifications channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'test_notifications',
            'Test Notifications',
            description: 'Test notifications for debugging',
            importance: Importance.high,
          ),
        );

        // Warning notifications channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'consumption_warnings',
            'Consumption Warnings',
            description: 'Warnings when consumption limits are exceeded',
            importance: Importance.high,
          ),
        );

        print('NotificationService: Android notification channels created');
      }
    }
  }
}
