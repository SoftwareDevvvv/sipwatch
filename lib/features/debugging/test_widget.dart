import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/controllers/drink_entry_controller.dart';
import '../settings/controllers/settings_controller.dart';

class TestWidget extends StatelessWidget {
  final SettingsController _settingsController = Get.find<SettingsController>();
  final DrinkEntryController _drinkEntryController =
      Get.find<DrinkEntryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Widget')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                'Water Daily Goal: ${_settingsController.waterDailyGoal.value}')),
            SizedBox(height: 20),
            Obx(() => Text('Total Consumption: ${_getTotalVolume()}')),
            SizedBox(height: 20),
            Obx(() =>
                Text('Daily Norm Percentage: ${_getDailyNormPercentage()}%')),
          ],
        ),
      ),
    );
  }

  int _getTotalVolume() {
    return _drinkEntryController.totalWaterToday.value +
        _drinkEntryController.totalCoffeeToday.value +
        _drinkEntryController.totalAlcoholToday.value;
  }

  int _getDailyNormPercentage() {
    final dailyNorm = _settingsController.waterDailyGoal.value;
    final totalVolume = _getTotalVolume();
    final percentage =
        totalVolume > 0 ? ((totalVolume / dailyNorm) * 100).round() : 0;
    print(
        'Calculating percentage: $totalVolume / $dailyNorm * 100 = $percentage');
    return percentage;
  }
}
