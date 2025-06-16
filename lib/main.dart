import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/add_fluid/controllers/fluid_controller.dart';
import 'features/calendar/screens/calendar_screen.dart';
import 'features/home/controllers/drink_entry_controller.dart';
import 'features/home/controllers/drink_image_controller.dart';
import 'features/home/screens/today_screen.dart';
import 'features/settings/controllers/settings_controller.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/stats/controllers/stats_controller.dart';
import 'features/stats/screens/stats_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); // Initialize core services
  Get.put(SettingsController()); // Register SettingsController first
  Get.put(NotificationService()); // Initialize notification service
  Get.put(
      FluidController()); // Register FluidController after SettingsController

  // Register data controllers
  Get.put(DrinkEntryController());
  Get.put(DrinkImageController());

  // We'll register StatsController lazily when the Stats screen is first loaded,
  // as it depends on DrinkEntryController

  runApp(SipWatchApp());
}

class SipWatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SipWatch',
      theme: AppTheme.lightTheme,
      home: MainScreen(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    TodayScreen(),
    CalendarScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar:
          Platform.isIOS ? _buildIOSBottomBar() : _buildAndroidBottomBar(),
    );
  }

  Widget _buildIOSBottomBar() {
    return CupertinoTabBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      backgroundColor: Colors.white,
      activeColor: Color(0xFF007AFF),
      inactiveColor: Color(0xFF8E8E93),
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/today_icon.svg',
            color: _currentIndex == 0 ? Color(0xFF007AFF) : AppColors.inactive,
          ),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/calendar_icon.svg',
            color: _currentIndex == 1 ? Color(0xFF007AFF) : AppColors.inactive,
          ),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/stats_icon.svg',
            color: _currentIndex == 2 ? Color(0xFF007AFF) : AppColors.inactive,
          ),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/settings_icon.svg',
            color: _currentIndex == 3 ? Color(0xFF007AFF) : AppColors.inactive,
          ),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildAndroidBottomBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      selectedLabelStyle: TextStyle(fontSize: 12, color: AppColors.textHint),
      unselectedItemColor: AppColors.textHint,
      backgroundColor: Color(0xFFE0E0E0),

      elevation: 8,
      selectedFontSize:
          12, // Set the same font size for both selected and unselected
      unselectedFontSize:
          12, // Set the same font size for both selected and unselected
      items: [
        BottomNavigationBarItem(
          icon: _buildNavIcon(0, 'assets/images/today_icon.svg'),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(1, 'assets/images/calendar_icon.svg'),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(2, 'assets/images/stats_icon.svg'),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: _buildNavIcon(3, 'assets/images/settings_icon.svg'),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildNavIcon(int index, String assetPath) {
    final bool isSelected = _currentIndex == index;
    return Container(
      width: isSelected
          ? 56
          : 24, // Keep the original width to maintain the oval shape
      height: isSelected
          ? 32
          : 24, // Keep the original height to maintain the oval shape
      decoration: isSelected
          ? BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: Center(
        child: SvgPicture.asset(
          assetPath,
          color: isSelected ? Color(0xFF0C4E6A) : AppColors.inactive,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
