import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/home/screens/today_screen.dart';
import '../../features/add_fluid/screens/add_fluid_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/stats/screens/stats_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => TodayScreen(),
      binding: BindingsBuilder(() {
        // Home bindings will be added later
      }),
    ),
    GetPage(
      name: AppRoutes.addFluid,
      page: () => FluidAdditionScreen(),
      binding: BindingsBuilder(() {
        // Add fluid bindings will be added later
      }),
    ),
    GetPage(
      name: AppRoutes.calendar,
      page: () => CalendarScreen(),
      binding: BindingsBuilder(() {
        // Calendar bindings will be added later
      }),
    ),
    GetPage(
      name: AppRoutes.stats,
      page: () => StatsScreen(),
      binding: BindingsBuilder(() {
        // Stats bindings will be added later
      }),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsScreen(),
      binding: BindingsBuilder(() {
        // Settings bindings will be added later
      }),
    ),
  ];
}
