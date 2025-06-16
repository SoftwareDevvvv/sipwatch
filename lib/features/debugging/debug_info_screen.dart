import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

class DebugInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Tap the button below to print debug info to console',
                style: AppTextStyles.bodyMedium),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                final controllers = Get.findAll();
                print('--- DEBUG INFO ---');
                print('Registered GetX Controllers:');
                for (final controller in controllers) {
                  print('- ${controller.runtimeType}');
                  if (controller.runtimeType
                      .toString()
                      .contains('SettingsController')) {
                    print(
                        '  Water Daily Goal: ${controller.waterDailyGoal?.value}');
                  }
                  if (controller.runtimeType
                      .toString()
                      .contains('DrinkEntryController')) {
                    print(
                        '  Total Water Today: ${controller.totalWaterToday?.value}');
                    print(
                        '  Total Coffee Today: ${controller.totalCoffeeToday?.value}');
                    print(
                        '  Total Alcohol Today: ${controller.totalAlcoholToday?.value}');

                    final totalConsumption =
                        (controller.totalWaterToday?.value ?? 0) +
                            (controller.totalCoffeeToday?.value ?? 0) +
                            (controller.totalAlcoholToday?.value ?? 0);

                    print('  Total Consumption: $totalConsumption ml');

                    // Try to access waterDailyGoal from SettingsController
                    try {
                      final settingsController =
                          Get.find(tag: 'SettingsController');
                      final waterGoal =
                          settingsController.waterDailyGoal?.value ?? 0;
                      print(
                          '  Water Daily Goal (from Settings): $waterGoal ml');
                      print(
                          '  Daily Norm %: ${(totalConsumption / waterGoal * 100).round()}%');
                    } catch (e) {
                      print('  Could not access SettingsController: $e');
                    }
                  }
                }
                print('-----------------');
              },
              child: Text('Print Debug Info'),
            ),
          ),
        ],
      ),
    );
  }
}
