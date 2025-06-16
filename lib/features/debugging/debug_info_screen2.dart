import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../features/settings/controllers/settings_controller.dart';
import '../../features/home/controllers/drink_entry_controller.dart';
import '../../features/add_fluid/controllers/fluid_controller.dart';

class DebugInfoScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Debug Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                'Tap the button below to print detailed controller info',
                style: AppTextStyles.bodyMedium),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                print('--- DETAILED DEBUG INFO ---');

                try {
                  final settingsController = Get.find<SettingsController>();
                  print('SettingsController:');
                  print(
                      '  Water Daily Goal: ${settingsController.waterDailyGoal.value} ml');
                } catch (e) {
                  print('Could not find SettingsController: $e');
                }

                try {
                  final fluidController = Get.find<FluidController>();
                  print('FluidController:');
                  print('  Daily Goal: ${fluidController.dailyGoal.value} ml');
                } catch (e) {
                  print('Could not find FluidController: $e');
                }

                try {
                  final drinkEntryController = Get.find<DrinkEntryController>();
                  print('DrinkEntryController:');
                  print(
                      '  Total Water: ${drinkEntryController.totalWaterToday.value} ml');
                  print(
                      '  Total Coffee: ${drinkEntryController.totalCoffeeToday.value} ml');
                  print(
                      '  Total Alcohol: ${drinkEntryController.totalAlcoholToday.value} ml');
                  final total = drinkEntryController.totalWaterToday.value +
                      drinkEntryController.totalCoffeeToday.value +
                      drinkEntryController.totalAlcoholToday.value;
                  print('  Total Volume: ${total} ml');

                  // Calculate percentages
                  try {
                    final settingsController = Get.find<SettingsController>();
                    final waterGoal = settingsController.waterDailyGoal.value;
                    print('  Daily Norm Calculation:');
                    print('    Total: $total ml');
                    print('    Goal (from Settings): $waterGoal ml');
                    print(
                        '    Percentage: ${(total / waterGoal * 100).round()}%');
                  } catch (e) {
                    print('  Could not access SettingsController: $e');
                  }
                } catch (e) {
                  print('Could not find DrinkEntryController: $e');
                }

                print('-------------------------');
              },
              child: Text('Print Detailed Debug Info'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Update SettingsController with value from text field
                try {
                  final settingsController = Get.find<SettingsController>();
                  print(
                      'Current water daily goal: ${settingsController.waterDailyGoal.value} ml');
                  // Force update with calculated value
                  final calculatedGoal = settingsController
                      .calculateDailyFluidRequirement()
                      .toInt();
                  settingsController.updateDailyNorms(water: calculatedGoal);
                  print(
                      'Updated water daily goal to: ${settingsController.waterDailyGoal.value} ml');
                } catch (e) {
                  print('Error updating water daily goal: $e');
                }
              },
              child: Text('Force Update Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
