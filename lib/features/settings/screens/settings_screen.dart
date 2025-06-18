import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_theme.dart';
import '../controllers/settings_controller.dart';
import '../../debugging/notification_test_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Get the settings controller
  final SettingsController _settingsController = Get.find<SettingsController>();
  String?
      _currentView; // null means showing main settings, otherwise shows specific screen
  final TextEditingController _nameController = TextEditingController();

  // Profile image state
  File? _selectedProfileImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Notification settings state
  bool dailyNotification = true;
  bool morningTips = false;
  bool waterWarning = false;
  bool coffeeWarning = false;
  bool alcoholWarning = false;

  // Daily norm state
  final TextEditingController _coffeeController =
      TextEditingController(text: '23 ml');
  final TextEditingController _waterController =
      TextEditingController(text: '23 ml');
  final TextEditingController _alcoholController =
      TextEditingController(text: '23 ml');
  // Body fluid calculation state
  String selectedGender = 'Male';
  final TextEditingController _weightController =
      TextEditingController(text: '73');
  String selectedActivity = 'Mild';

  // Calculate daily fluid requirement
  double calculateDailyFluidRequirement() {
    // Extract numeric value from weight
    double weight = double.tryParse(
            _weightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ??
        70;

    // Base water requirement (ml per kg)
    double baseRequirement;
    if (selectedGender == 'Male') {
      baseRequirement = 35; // ml per kg for males
    } else {
      baseRequirement = 31; // ml per kg for females
    }

    // Activity multiplier
    double activityMultiplier;
    switch (selectedActivity) {
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

    return weight * baseRequirement * activityMultiplier;
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers with values from SettingsController
    _nameController.text = _settingsController.userName.value;
    _weightController.text = _settingsController.weight.value.toString();

    // Load profile image if available
    if (_settingsController.userProfileImagePath.value.isNotEmpty) {
      _selectedProfileImage =
          File(_settingsController.userProfileImagePath.value);
    }

    // Initialize daily norm controllers
    _waterController.text = '${_settingsController.waterDailyGoal.value} ml';
    _coffeeController.text = '${_settingsController.coffeeDailyLimit.value} ml';
    _alcoholController.text =
        '${_settingsController.alcoholDailyLimit.value} ml'; // Initialize notification settings
    dailyNotification = _settingsController.dailyNotification.value;
    morningTips = _settingsController.morningTips.value;
    waterWarning = _settingsController.waterWarning.value;
    coffeeWarning = _settingsController.coffeeWarning.value;
    alcoholWarning = _settingsController.alcoholWarning.value;

    // Initialize body fluid calculation settings
    selectedGender = _settingsController.gender.value;
    selectedActivity = _settingsController.activityLevel.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _currentView == null
          ? PreferredSize(
              preferredSize: Size.fromHeight(AppDimensions.appBarHeight),
              child: Container(
                color: AppColors.background,
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Settings',
                      style: AppTextStyles.heading2,
                    ),
                  ),
                ),
              ),
            )
          : PreferredSize(
              preferredSize:
                  Size.fromHeight(60), // Smaller height for just back button
              child: Container(
                color: AppColors.background,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 80, // Fixed width for the back button
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentView = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF29B6F6),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.radiusM),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      body: _currentView == null ? _buildMainSettings() : _buildCurrentView(),
    );
  }

  Widget _buildMainSettings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSettingsCard(
            iconPath: 'assets/images/person.svg',
            title: 'Personal Information',
            buttonText: 'Edit',
            onTap: () {
              setState(() {
                _currentView = 'personal_info';
              });
            },
          ),
          SizedBox(height: 16),
          _buildSettingsCard(
            iconPath: 'assets/images/notification_icon.svg',
            title: 'Notification settings',
            buttonText: 'Edit',
            onTap: () {
              setState(() {
                _currentView = 'notifications';
              });
            },
          ),
          SizedBox(height: 16),
          _buildSettingsCard(
            iconPath: 'assets/images/daily_norm.svg',
            title: 'Daily norm',
            buttonText: 'Edit',
            onTap: () {
              setState(() {
                _currentView = 'daily_norm';
              });
            },
          ),
          SizedBox(height: 16),
          _buildSettingsCard(
            iconPath: 'assets/images/calculator.svg',
            title: 'Calculation of body\nfluid requirements',
            buttonText: 'Open',
            onTap: () {
              setState(() {
                _currentView = 'body_fluid';
              });
            },
          ),
          SizedBox(height: 16),
          // Only show test notifications in debug mode
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 'personal_info':
        return _buildPersonalInfoContent();
      case 'notifications':
        return _buildNotificationContent();
      case 'daily_norm':
        return _buildDailyNormContent();
      case 'body_fluid':
        return _buildBodyFluidContent();
      default:
        return _buildMainSettings();
    }
  }

  Widget _buildPersonalInfoContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen title
            Text(
              'Personal Information',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 24),
            // Name field
            const Text(
              'Name',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  hintStyle: TextStyle(
                    color: Color(0xFF1B365D),
                    fontSize: 16,
                  ),
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Photo field
            const Text(
              'Photo',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showImageSourceModal,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: AppColors.inputBorder, width: 1),
                ),
                child: _selectedProfileImage != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusM),
                        child: Image.file(
                          _selectedProfileImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32), // Save button
            Center(
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    // Save personal information to settings controller
                    _settingsController.updatePersonalInfo(
                      name: _nameController.text.trim(),
                      profileImagePath: _selectedProfileImage?.path ?? '',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Personal information saved'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen title
            Text(
              'Notification Settings',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 24), // Toggle switches
            _buildToggleItem('Daily Notification', dailyNotification, (value) {
              setState(() => dailyNotification = value);
            }),
            const SizedBox(height: 24),
            _buildToggleItem('Morning tips', morningTips, (value) {
              setState(() => morningTips = value);
            }),
            const SizedBox(height: 24),
            _buildToggleItem('norm transition warning for water', waterWarning,
                (value) {
              setState(() => waterWarning = value);
            }),
            const SizedBox(height: 24),
            _buildToggleItem(
                'norm transition warning for Coffee', coffeeWarning, (value) {
              setState(() => coffeeWarning = value);
            }),
            const SizedBox(height: 24),
            _buildToggleItem(
                'norm transition warning for Alcohol', alcoholWarning, (value) {
              setState(() => alcoholWarning = value);
            }),
            const SizedBox(height: 32), // Save button
            Center(
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    // Save all notification settings to the controller
                    _settingsController.updateNotificationSettings(
                      daily: dailyNotification,
                      tips: morningTips,
                      water: waterWarning,
                      coffee: coffeeWarning,
                      alcohol: alcoholWarning,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Notification settings saved'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyNormContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen title
            Text(
              'Daily Norm',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 24),
            // Coffee Daily Norm
            const Text(
              'Coffee Daily Norm',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: TextField(
                controller: _coffeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  hintText: 'Enter coffee daily norm in ml',
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Water Daily Norm
            const Text(
              'Water Daily Norm',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: TextField(
                controller: _waterController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  hintText: 'Enter water daily norm in ml',
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Alcohol Daily Norm
            const Text(
              'Alcohol Daily Norm',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: TextField(
                controller: _alcoholController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  hintText: 'Enter alcohol daily norm in ml',
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 32), // Save button
            Center(
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    // Extract values from text controllers
                    int waterGoal = int.tryParse(_waterController.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        2500;
                    int coffeeLimit = int.tryParse(_coffeeController.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        400;
                    int alcoholLimit = int.tryParse(_alcoholController.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        200;

                    // Update the settings controller
                    _settingsController.updateDailyNorms(
                      water: waterGoal,
                      coffee: coffeeLimit,
                      alcohol: alcoholLimit,
                    );

                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Daily norms saved'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyFluidContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen title
            Text(
              'Body Fluid Calculation',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 24),
            // Gender dropdown
            const Text(
              'Gender',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                dropdownColor: AppColors.surfaceVariant,
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            // Weight field
            const Text(
              'Weight (kg)',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  hintText: 'Enter your weight',
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to update calculation
                },
              ),
            ),
            const SizedBox(height: 24),
            // Physical Activity dropdown
            const Text(
              'Physical Activity',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedActivity,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                dropdownColor: AppColors.surfaceVariant,
                items:
                    ['Light', 'Mild', 'Moderate', 'Heavy'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedActivity = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            // Daily Norm Result
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.inputColor,
                    AppColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Daily Norm',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${calculateDailyFluidRequirement().round()} ml',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on ${selectedGender.toLowerCase()}, ${_weightController.text.replaceAll(RegExp(r'[^0-9.]'), '')} kg, ${selectedActivity.toLowerCase()} activity',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // Save button
            Center(
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    // Calculate the daily norm
                    double dailyNorm = calculateDailyFluidRequirement();

                    // Update the settings controller with the new value
                    _settingsController.updateBodyFluidSettings(
                      gender: selectedGender,
                      weight: double.tryParse(_weightController.text) ?? 70.0,
                      activityLevel: selectedActivity,
                    );

                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Daily norm saved: ${dailyNorm.round()} ml'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String iconPath,
    required String title,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Circular container with SVG icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFC5EFFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                color: Color(0xFF70ACC3),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1F),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF29B6F6),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Add Profile Photo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B365D),
                    ),
                  ),
                ),

                // Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildImageSourceOption(
                        icon: Icons.photo_library,
                        title: 'Choose from Gallery',
                        subtitle: 'Select an existing photo',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromGallery();
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildImageSourceOption(
                        icon: Icons.camera_alt,
                        title: 'Take Photo',
                        subtitle: 'Use camera to take a new photo',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromCamera();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.inputColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedProfileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image from gallery'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedProfileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error taking photo with camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take photo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
