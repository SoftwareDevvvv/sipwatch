import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/add_fluid/controllers/fluid_controller.dart';
import '../../../core/services/notification_service.dart';

/// A controller for managing and persisting user settings throughout the app.
/// This controller handles all settings-related functionality like saving,
/// loading, and providing access to user preferences.
class SettingsController extends GetxController {
  // Personal Information
  final RxString userName = ''.obs;
  final RxString userProfileImagePath = ''.obs;

  // Notification Settings
  final RxBool dailyNotification = true.obs;
  final RxBool morningTips = false.obs;
  final RxBool waterWarning = false.obs;
  final RxBool coffeeWarning = false.obs;
  final RxBool alcoholWarning = false.obs;

  // Daily Norm Settings
  final RxInt waterDailyGoal = 2500.obs; // in ml
  final RxInt coffeeDailyLimit = 400.obs; // in ml
  final RxInt alcoholDailyLimit = 200.obs; // in ml

  // Body Fluid Calculation Settings
  final RxString gender = 'Male'.obs;
  final RxDouble weight = 70.0.obs; // in kg
  final RxString activityLevel = 'Mild'.obs;

  // Singleton instance
  static SettingsController get to => Get.find<SettingsController>();

  // SharedPreferences instance
  late SharedPreferences _prefs;
  @override
  void onInit() async {
    super.onInit();
    await _initPrefs();
    await loadSettings();

    // Calculate and update water daily goal if needed
    if (waterDailyGoal.value == 2500) {
      int calculatedGoal = calculateDailyFluidRequirement().toInt();
      if (calculatedGoal > 0 && calculatedGoal != 2500) {
        updateDailyNorms(water: calculatedGoal);
        print(
            'Initialized water daily goal to calculated value: $calculatedGoal ml');
      }
    }
  }

  /// Initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Load all settings from SharedPreferences
  Future<void> loadSettings() async {
    // Make sure SharedPreferences is initialized
    if (!Get.isRegistered<SharedPreferences>()) {
      await _initPrefs();
    } // Load Personal Information
    userName.value = _prefs.getString('userName') ?? '';
    userProfileImagePath.value = _prefs.getString('userProfileImagePath') ?? '';
    userProfileImagePath.value = _prefs.getString('userProfileImagePath') ?? '';

    // Load Notification Settings
    dailyNotification.value = _prefs.getBool('dailyNotification') ?? true;
    morningTips.value = _prefs.getBool('morningTips') ?? false;
    waterWarning.value = _prefs.getBool('waterWarning') ?? false;
    coffeeWarning.value = _prefs.getBool('coffeeWarning') ?? false;
    alcoholWarning.value = _prefs.getBool('alcoholWarning') ?? false;

    // Load Daily Norm Settings
    waterDailyGoal.value = _prefs.getInt('waterDailyGoal') ?? 2500;
    coffeeDailyLimit.value = _prefs.getInt('coffeeDailyLimit') ?? 400;
    alcoholDailyLimit.value = _prefs.getInt('alcoholDailyLimit') ?? 200;

    // Load Body Fluid Calculation Settings
    gender.value = _prefs.getString('gender') ?? 'Male';
    weight.value = _prefs.getDouble('weight') ?? 70.0;
    activityLevel.value = _prefs.getString('activityLevel') ?? 'Mild';
  }

  /// Save all settings to SharedPreferences
  Future<void> saveSettings() async {
    // Make sure SharedPreferences is initialized
    if (!Get.isRegistered<SharedPreferences>()) {
      await _initPrefs();
    } // Save Personal Information
    await _prefs.setString('userName', userName.value);
    await _prefs.setString('userProfileImagePath', userProfileImagePath.value);
    await _prefs.setString('userProfileImagePath', userProfileImagePath.value);

    // Save Notification Settings
    await _prefs.setBool('dailyNotification', dailyNotification.value);
    await _prefs.setBool('morningTips', morningTips.value);
    await _prefs.setBool('waterWarning', waterWarning.value);
    await _prefs.setBool('coffeeWarning', coffeeWarning.value);
    await _prefs.setBool('alcoholWarning', alcoholWarning.value);

    // Save Daily Norm Settings
    await _prefs.setInt('waterDailyGoal', waterDailyGoal.value);
    await _prefs.setInt('coffeeDailyLimit', coffeeDailyLimit.value);
    await _prefs.setInt('alcoholDailyLimit', alcoholDailyLimit.value);

    // Save Body Fluid Calculation Settings
    await _prefs.setString('gender', gender.value);
    await _prefs.setDouble('weight', weight.value);
    await _prefs.setString('activityLevel', activityLevel.value);
  }

  /// Update personal information and save to storage
  void updatePersonalInfo({String? name, String? profileImagePath}) {
    if (name != null) userName.value = name;
    if (profileImagePath != null) userProfileImagePath.value = profileImagePath;
    saveSettings();
  }

  /// Update notification settings and save to storage
  void updateNotificationSettings({
    bool? daily,
    bool? tips,
    bool? water,
    bool? coffee,
    bool? alcohol,
  }) {
    if (daily != null) dailyNotification.value = daily;
    if (tips != null) morningTips.value = tips;
    if (water != null) waterWarning.value = water;
    if (coffee != null) coffeeWarning.value = coffee;
    if (alcohol != null) alcoholWarning.value = alcohol;
    saveSettings();

    // Update notification service when settings change
    if (Get.isRegistered<NotificationService>()) {
      final notificationService = Get.find<NotificationService>();
      notificationService.updateNotificationSettings();
    }
  }

  /// Update daily norm settings and save to storage
  void updateDailyNorms({
    int? water,
    int? coffee,
    int? alcohol,
  }) {
    if (water != null) waterDailyGoal.value = water;
    if (coffee != null) coffeeDailyLimit.value = coffee;
    if (alcohol != null) alcoholDailyLimit.value = alcohol;
    saveSettings();

    // If we are integrated with FluidController, update its daily goal
    if (Get.isRegistered<FluidController>()) {
      final fluidController = Get.find<FluidController>();
      fluidController.updateDailyGoal(waterDailyGoal.value);
    }
  }

  /// Update body fluid calculation settings and save to storage
  void updateBodyFluidSettings({
    String? gender,
    double? weight,
    String? activityLevel,
  }) {
    if (gender != null) this.gender.value = gender;
    if (weight != null) this.weight.value = weight;
    if (activityLevel != null) this.activityLevel.value = activityLevel;
    saveSettings();

    // Calculate new water daily goal based on body fluid requirements
    int calculatedGoal = calculateDailyFluidRequirement().toInt();
    updateDailyNorms(water: calculatedGoal);
  }

  /// Calculate daily fluid requirement based on body metrics
  double calculateDailyFluidRequirement() {
    // Base water requirement (ml per kg)
    double baseRequirement = gender.value == 'Male' ? 35 : 31;

    // Activity multiplier
    double activityMultiplier;
    switch (activityLevel.value) {
      case 'Light':
        activityMultiplier = 1.0;
        break;
      case 'Mild':
        activityMultiplier = 1.2;
        break;
      case 'Moderate':
        activityMultiplier = 1.4;
        break;
      case 'Heavy':
        activityMultiplier = 1.6;
        break;
      default:
        activityMultiplier = 1.2;
    }

    return weight.value * baseRequirement * activityMultiplier;
  }
}
