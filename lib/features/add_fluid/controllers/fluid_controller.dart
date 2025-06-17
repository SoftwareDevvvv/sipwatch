import 'package:get/get.dart';
import 'dart:math';

import '../../../features/home/models/drink_entry.dart';
import '../../home/models/drink_image.dart';
import '../../settings/controllers/settings_controller.dart';

class FluidController extends GetxController {
  // Observable list to hold all drink entries
  final RxList<DrinkEntry> drinkEntries = <DrinkEntry>[].obs;

  // Observable for total consumed volume today
  final RxInt todayTotalVolume = 0.obs;

  // Observable for daily goal (in ml) - Now initialized from SettingsController
  final RxInt dailyGoal = 0.obs;

  // Observable for progress percentage
  final RxDouble progressPercentage = 0.0.obs;

  // Settings controller for getting the water daily goal
  late final SettingsController _settingsController;

  @override
  void onInit() {
    super.onInit();

    // Initialize settings controller and get daily goal from it
    try {
      _settingsController = Get.find<SettingsController>();
      dailyGoal.value = _settingsController.waterDailyGoal.value;

      // Listen for changes to the water daily goal
      ever(_settingsController.waterDailyGoal, (value) {
        dailyGoal.value = value;
        _calculateStatistics();
      });
    } catch (e) {
      print('Error initializing settings controller: $e');
      dailyGoal.value = 2500; // Fallback value
    }

    // When initialized, calculate the initial statistics
    _calculateStatistics();
  }

  // Add a new drink entry
  void addDrinkEntry(DrinkEntry entry) {
    drinkEntries.add(entry);
    _calculateStatistics();
  }

  // Remove a specific drink entry
  void removeDrinkEntry(DrinkEntry entry) {
    drinkEntries.remove(entry);
    _calculateStatistics();
  }

  // Update an existing drink entry
  void updateDrinkEntry(DrinkEntry oldEntry, DrinkEntry newEntry) {
    // Find the index of the old entry
    int index = drinkEntries.indexOf(oldEntry);

    if (index != -1) {
      // Replace the old entry with the new one
      drinkEntries[index] = newEntry;
      _calculateStatistics();
    }
  }

  // Update daily goal
  void updateDailyGoal(int newGoal) {
    dailyGoal.value = newGoal;
    _calculateStatistics();
  }

  // Calculate statistics based on current entries
  void _calculateStatistics() {
    // Calculate total volume consumed today
    int total = 0;
    for (var entry in drinkEntries) {
      total += entry.volume;
    }

    todayTotalVolume.value = total;

    // Calculate progress percentage
    progressPercentage.value = dailyGoal.value > 0
        ? (todayTotalVolume.value / dailyGoal.value).clamp(0.0, 1.0)
        : 0.0;
  }

  // Get today's entries (filtering could be added later if needed)
  List<DrinkEntry> getTodayEntries() {
    return drinkEntries;
  }

  // Get total caffeine consumed today
  double getTotalCaffeineToday() {
    double totalCaffeine = 0.0;
    for (var entry in drinkEntries) {
      if (entry.type == DrinkType.coffee && entry.caffeine != null) {
        totalCaffeine += entry.caffeine!;
      }
    }
    return totalCaffeine;
  }

  // Get entries by drink type
  List<DrinkEntry> getEntriesByType(DrinkType type) {
    return drinkEntries.where((entry) => entry.type == type).toList();
  }

  // Get total volume by drink type
  int getTotalVolumeByType(DrinkType type) {
    int total = 0;
    for (var entry in drinkEntries.where((entry) => entry.type == type)) {
      total += entry.volume;
    }
    return total;
  }

  // Get entries for a specific date
  List<DrinkEntry> getEntriesForDate(DateTime date) {
    return drinkEntries
        .where((entry) =>
            entry.date.year == date.year &&
            entry.date.month == date.month &&
            entry.date.day == date.day)
        .toList();
  }

  // Get total volume for a specific date
  int getTotalVolumeForDate(DateTime date) {
    int total = 0;
    for (var entry in getEntriesForDate(date)) {
      total += entry.volume;
    }
    return total;
  }

  // Get consumption percentage for a specific date
  double getConsumptionPercentageForDate(DateTime date) {
    int total = getTotalVolumeForDate(date);
    return dailyGoal.value > 0
        ? (total / dailyGoal.value).clamp(0.0, 1.0)
        : 0.0;
  }

  // Get entries for a specific month
  List<DrinkEntry> getEntriesForMonth(int year, int month) {
    return drinkEntries
        .where((entry) => entry.date.year == year && entry.date.month == month)
        .toList();
  }

  // Get most consumed drink type for a date
  DrinkType? getMostConsumedTypeForDate(DateTime date) {
    final entries = getEntriesForDate(date);
    if (entries.isEmpty) return null;

    Map<DrinkType, int> volumeByType = {};

    for (var entry in entries) {
      volumeByType[entry.type] = (volumeByType[entry.type] ?? 0) + entry.volume;
    }

    DrinkType? maxType;
    int maxVolume = 0;

    volumeByType.forEach((type, volume) {
      if (volume > maxVolume) {
        maxVolume = volume;
        maxType = type;
      }
    });

    return maxType;
  }

  // Get days in a month with drinks logged
  List<int> getDaysWithDrinksInMonth(int year, int month) {
    final entries = getEntriesForMonth(year, month);
    final Set<int> daysWithDrinks = {};

    for (var entry in entries) {
      daysWithDrinks.add(entry.date.day);
    }

    return daysWithDrinks.toList()..sort();
  }

  // Clear all entries (for testing or resetting)
  void clearAllEntries() {
    drinkEntries.clear();
    _calculateStatistics();
  }

  // Get entries for a specific week
  List<DrinkEntry> getEntriesForWeek(DateTime date) {
    // Calculate the start of the week (Sunday)
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    final startDate =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    // Calculate the end of the week (Saturday)
    final endDate = startDate.add(const Duration(days: 6));

    return drinkEntries
        .where((entry) =>
            entry.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            entry.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  // Get daily volumes for a week
  List<Map<String, dynamic>> getDailyVolumesForWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    final weekEntries = getEntriesForWeek(date);

    List<Map<String, dynamic>> result = [];

    for (int i = 0; i < 7; i++) {
      final currentDate = startOfWeek.add(Duration(days: i));

      // Filter entries for this day
      final dayEntries = weekEntries
          .where((entry) =>
              entry.date.year == currentDate.year &&
              entry.date.month == currentDate.month &&
              entry.date.day == currentDate.day)
          .toList();

      // Calculate volumes by type
      int waterVolume = 0;
      int coffeeVolume = 0;
      int alcoholVolume = 0;

      for (var entry in dayEntries) {
        switch (entry.type) {
          case DrinkType.water:
            waterVolume += entry.volume;
            break;
          case DrinkType.coffee:
            coffeeVolume += entry.volume;
            break;
          case DrinkType.alcohol:
            alcoholVolume += entry.volume;
            break;
          case DrinkType.other:
          // TODO: Handle this case.
        }
      }

      result.add({
        'day': i,
        'date': currentDate,
        'waterVolume': waterVolume,
        'coffeeVolume': coffeeVolume,
        'alcoholVolume': alcoholVolume,
        'totalVolume': waterVolume + coffeeVolume + alcoholVolume,
      });
    }

    return result;
  }

  // Get weekly volumes for a month
  List<Map<String, dynamic>> getWeeklyVolumesForMonth(int year, int month) {
    // Get entries for the specified month
    final monthEntries = getEntriesForMonth(year, month);

    // Determine the last day of the month
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    final totalDays = lastDayOfMonth.day;

    // Roughly divide the month into 4 weeks
    List<Map<String, dynamic>> result = [];

    for (int weekIndex = 0; weekIndex < 4; weekIndex++) {
      final startDay = weekIndex * 7 + 1;
      final endDay = min((weekIndex + 1) * 7, totalDays);

      // Filter entries for this week
      final weekEntries = monthEntries
          .where(
              (entry) => entry.date.day >= startDay && entry.date.day <= endDay)
          .toList();

      // Calculate volumes by type
      int waterVolume = 0;
      int coffeeVolume = 0;
      int alcoholVolume = 0;

      for (var entry in weekEntries) {
        switch (entry.type) {
          case DrinkType.water:
            waterVolume += entry.volume;
            break;
          case DrinkType.coffee:
            coffeeVolume += entry.volume;
            break;
          case DrinkType.alcohol:
            alcoholVolume += entry.volume;
            break;
          case DrinkType.other:
          // TODO: Handle this case.
        }
      }

      result.add({
        'week': weekIndex,
        'waterVolume': waterVolume,
        'coffeeVolume': coffeeVolume,
        'alcoholVolume': alcoholVolume,
        'totalVolume': waterVolume + coffeeVolume + alcoholVolume,
      });
    }

    return result;
  }
}
