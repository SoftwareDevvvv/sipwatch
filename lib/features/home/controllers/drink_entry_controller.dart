import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../models/drink_entry.dart';
import '../models/drink_image.dart';
import '../../../core/services/notification_service.dart';

class DrinkEntryController extends GetxController {
  late SharedPreferences _prefs;
  final String _storageKey = 'drink_entries';

  // Observable lists for UI
  final RxList<DrinkEntry> allDrinks = <DrinkEntry>[].obs;
  final RxList<DrinkEntry> todayDrinks = <DrinkEntry>[].obs;

  // Stats observables
  final RxInt totalWaterToday = 0.obs;
  final RxInt totalCoffeeToday = 0.obs;
  final RxInt totalAlcoholToday = 0.obs;
  final RxDouble totalCaffeineToday = 0.0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    isLoading.value = true;
    _prefs = await SharedPreferences.getInstance();
    await _loadDrinks();
    isLoading.value = false;
  }

  // Load all drinks from shared preferences
  Future<void> _loadDrinks() async {
    try {
      final drinkEntriesJson = _prefs.getStringList(_storageKey) ?? [];

      final drinks = drinkEntriesJson
          .map((json) => DrinkEntry.fromJson(jsonDecode(json)))
          .toList();

      allDrinks.value = drinks;
      _updateTodayDrinks();
      _calculateStats();
    } catch (e) {
      print('Error loading drinks: $e');
      allDrinks.value = [];
    }
  }

  // Save drinks to shared preferences
  Future<void> _saveDrinks() async {
    try {
      final drinkEntriesJson =
          allDrinks.map((drink) => jsonEncode(drink.toJson())).toList();

      await _prefs.setStringList(_storageKey, drinkEntriesJson);
    } catch (e) {
      print('Error saving drinks: $e');
    }
  }

  // Filter drinks for today
  void _updateTodayDrinks() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    todayDrinks.value = allDrinks
        .where((drink) =>
            drink.date.isAfter(startOfDay) && drink.date.isBefore(endOfDay))
        .toList();

    // Sort by time, latest first
    todayDrinks
        .sort((a, b) => _parseTime(b.time).compareTo(_parseTime(a.time)));
  }

  // Helper to parse time strings like "13:45"
  DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    final parts = timeStr.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return DateTime(now.year, now.month, now.day, hour, minute);
    }
    return now;
  }

  // Calculate drink statistics
  void _calculateStats() {
    totalWaterToday.value = 0;
    totalCoffeeToday.value = 0;
    totalAlcoholToday.value = 0;
    totalCaffeineToday.value = 0.0;

    for (final drink in todayDrinks) {
      switch (drink.type) {
        case DrinkType.water:
          totalWaterToday.value += drink.volume;
          break;
        case DrinkType.coffee:
          totalCoffeeToday.value += drink.volume;
          if (drink.caffeine != null) {
            totalCaffeineToday.value += drink.caffeine!;
          }
          break;
        case DrinkType.alcohol:
        default:
          totalAlcoholToday.value += drink.volume;
          break;
      }
    }
  }

  // Get percentages for the daily consumption graph
  double getWaterPercentage() {
    final total = totalWaterToday.value +
        totalCoffeeToday.value +
        totalAlcoholToday.value;
    return total > 0 ? (totalWaterToday.value / total) * 100 : 0;
  }

  double getCoffeePercentage() {
    final total = totalWaterToday.value +
        totalCoffeeToday.value +
        totalAlcoholToday.value;
    return total > 0 ? (totalCoffeeToday.value / total) * 100 : 0;
  }

  double getAlcoholPercentage() {
    final total = totalWaterToday.value +
        totalCoffeeToday.value +
        totalAlcoholToday.value;
    return total > 0 ? (totalAlcoholToday.value / total) * 100 : 0;
  }

  // Add a new drink
  Future<void> addDrink(DrinkEntry drink) async {
    allDrinks.add(drink);
    await _saveDrinks();
    _updateTodayDrinks();
    _calculateStats();

    // Check for notification warnings after adding the drink
    await _checkNotificationWarnings();
  }

  // Check for notification warnings based on current consumption
  Future<void> _checkNotificationWarnings() async {
    try {
      final notificationService = Get.find<NotificationService>();

      // Check water warnings
      await notificationService.checkWaterWarning(totalWaterToday.value);

      // Check coffee warnings
      await notificationService.checkCoffeeWarning(totalCoffeeToday.value);

      // Check alcohol warnings
      await notificationService.checkAlcoholWarning(totalAlcoholToday.value);
    } catch (e) {
      print('Error checking notification warnings: $e');
    }
  }

  // Get a drink by ID
  DrinkEntry? getDrinkById(String id) {
    try {
      return allDrinks.firstWhere((drink) => drink.id == id);
    } catch (e) {
      print('Error getting drink by ID: $e');
      return null;
    }
  }

  // Update an existing drink
  Future<void> updateDrink(DrinkEntry updatedDrink) async {
    final index = allDrinks.indexWhere((drink) => drink.id == updatedDrink.id);
    if (index != -1) {
      allDrinks[index] = updatedDrink;
      await _saveDrinks();
      _updateTodayDrinks();
      _calculateStats();

      // Check for notification warnings after updating the drink
      await _checkNotificationWarnings();
    }
  }

  // Delete a drink
  Future<void> deleteDrink(String id) async {
    allDrinks.removeWhere((drink) => drink.id == id);
    await _saveDrinks();
    _updateTodayDrinks();
    _calculateStats();
  }

  // Format a DateTime to a time string (e.g. "13:45")
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  // Get drinks for a specific date
  List<DrinkEntry> getDrinksForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return allDrinks
        .where((drink) =>
            drink.date.isAfter(startOfDay) && drink.date.isBefore(endOfDay))
        .toList();
  }

  // Get total volume by drink type for a specific date
  int getTotalVolumeByType(DateTime date, DrinkType type) {
    final drinks = getDrinksForDate(date);
    return drinks
        .where((drink) => drink.type == type)
        .fold(0, (sum, drink) => sum + drink.volume);
  }

  // Get total caffeine for a specific date
  double getTotalCaffeineForDate(DateTime date) {
    final drinks = getDrinksForDate(date);
    return drinks
        .where((drink) => drink.caffeine != null)
        .fold(0.0, (sum, drink) => sum + (drink.caffeine ?? 0.0));
  }

  // Add methods to calculate stats for a specific date
  Map<String, dynamic> calculateStatsForDate(DateTime date) {
    final drinks = getDrinksForDate(date);

    // Calculate totals for this date
    int totalWater = 0;
    int totalCoffee = 0;
    int totalAlcohol = 0;
    double totalCaffeine = 0.0;

    for (final drink in drinks) {
      switch (drink.type) {
        case DrinkType.water:
          totalWater += drink.volume;
          break;
        case DrinkType.coffee:
          totalCoffee += drink.volume;
          if (drink.caffeine != null) {
            totalCaffeine += drink.caffeine!;
          }
          break;
        case DrinkType.alcohol:
        default:
          totalAlcohol += drink.volume;
          break;
      }
    }

    // Return totals via these calculated values
    print(
        'Stats for ${date.toString().split(' ')[0]}: Water=$totalWater ml, Coffee=$totalCoffee ml, Alcohol=$totalAlcohol ml');
    return {
      'totalWater': totalWater,
      'totalCoffee': totalCoffee,
      'totalAlcohol': totalAlcohol,
      'totalCaffeine': totalCaffeine,
      'totalVolume': totalWater + totalCoffee + totalAlcohol,
    };
  }

  // Get percentages for a specific date for the daily consumption graph
  Map<String, double> getPercentagesForDate(DateTime date) {
    final stats = calculateStatsForDate(date);
    final int totalWater = stats['totalWater']!;
    final int totalCoffee = stats['totalCoffee']!;
    final int totalAlcohol = stats['totalAlcohol']!;
    final int total = stats['totalVolume']!;
    ;

    double waterPercentage = total > 0 ? (totalWater / total) * 100 : 0;
    double coffeePercentage = total > 0 ? (totalCoffee / total) * 100 : 0;
    double alcoholPercentage = total > 0 ? (totalAlcohol / total) * 100 : 0;

    return {
      'water': waterPercentage,
      'coffee': coffeePercentage,
      'alcohol': alcoholPercentage,
    };
  }

  // Get the most consumed drink type for a specific date
  DrinkType getMostConsumedTypeForDate(DateTime date) {
    final stats = calculateStatsForDate(date);
    final int totalWater = stats['totalWater']!;
    final int totalCoffee = stats['totalCoffee']!;
    final int totalAlcohol = stats['totalAlcohol']!;

    if (totalWater >= totalCoffee && totalWater >= totalAlcohol) {
      return DrinkType.water;
    } else if (totalCoffee >= totalWater && totalCoffee >= totalAlcohol) {
      return DrinkType.coffee;
    } else {
      return DrinkType.alcohol;
    }
  }

  // Calculate the percentage of daily norm achieved for a specific date
  int getDailyNormPercentageForDate(DateTime date, int dailyNorm) {
    if (dailyNorm <= 0) return 0;

    final stats = calculateStatsForDate(date);
    final int totalVolume = stats['totalVolume']!;

    return totalVolume > 0 ? ((totalVolume / dailyNorm) * 100).round() : 0;
  }
}
