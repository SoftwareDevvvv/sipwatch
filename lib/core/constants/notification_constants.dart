class NotificationConstants {
  // Channel Information
  static const String hydrationChannelId = 'hydration_reminders';
  static const String hydrationChannelName = 'Hydration Reminders';
  static const String hydrationChannelDescription =
      'Reminders to stay hydrated throughout the day';

  static const String warningChannelId = 'consumption_warnings';
  static const String warningChannelName = 'Consumption Warnings';
  static const String warningChannelDescription =
      'Warnings when consumption limits are exceeded';

  // Default Notification Messages
  static const String defaultHydrationTitle = 'Time to Hydrate! 💧';
  static const String defaultHydrationBody =
      'Don\'t forget to drink some water!';

  static const String waterWarningTitle = 'Water Goal Achieved! 🎉';
  static const String waterWarningBody = 'Great job staying hydrated today!';

  static const String coffeeWarningTitle = 'Coffee Limit Reached ☕';
  static const String coffeeWarningBody =
      'Consider switching to water for the rest of the day.';

  static const String alcoholWarningTitle = 'Alcohol Consumption Notice 🍷';
  static const String alcoholWarningBody =
      'Please drink responsibly and stay hydrated.';

  // Morning Tips
  static const List<String> morningTips = [
    'Start your day with a glass of water! 💧',
    'Hydration is key to a productive day! 🌟',
    'Your body is 60% water - keep it topped up! 💪',
    'Morning water boost: your brain will thank you! 🧠',
    'Kickstart your metabolism with water! 🔥',
  ];

  // Default Reminder Times (in hours)
  static const List<int> defaultReminderHours = [8, 12, 16, 20];
}
