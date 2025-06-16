import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/notification_service.dart';
import '../../../features/settings/controllers/settings_controller.dart';
import '../../../features/home/controllers/drink_entry_controller.dart';

class NotificationTestScreen extends StatelessWidget {
  const NotificationTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationService = Get.find<NotificationService>();
    final settingsController = Get.find<SettingsController>();
    final drinkController = Get.find<DrinkEntryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Notification System Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Current consumption display
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Today\'s Consumption:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                            'Water: ${drinkController.totalWaterToday.value}ml'),
                        Text(
                            'Coffee: ${drinkController.totalCoffeeToday.value}ml'),
                        Text(
                            'Alcohol: ${drinkController.totalAlcoholToday.value}ml'),
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 20),

            // Notification settings display
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Notification Settings:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                            'Daily Notifications: ${settingsController.dailyNotification.value ? "ON" : "OFF"}'),
                        Text(
                            'Morning Tips: ${settingsController.morningTips.value ? "ON" : "OFF"}'),
                        Text(
                            'Water Warning: ${settingsController.waterWarning.value ? "ON" : "OFF"}'),
                        Text(
                            'Coffee Warning: ${settingsController.coffeeWarning.value ? "ON" : "OFF"}'),
                        Text(
                            'Alcohol Warning: ${settingsController.alcoholWarning.value ? "ON" : "OFF"}'),
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 20),

            // Test buttons
            ElevatedButton(
              onPressed: () async {
                await notificationService.scheduleDailyMorningTip();
                Get.snackbar(
                    'Test', 'Morning tip scheduled for tomorrow 8:00 AM',
                    backgroundColor: Colors.green, colorText: Colors.white);
              },
              child: const Text('Test Morning Tip Scheduling'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                notificationService.resetDailyWarnings();
                Get.snackbar('Test', 'Daily warning flags reset',
                    backgroundColor: Colors.blue, colorText: Colors.white);
              },
              child: const Text('Test Warning Reset'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                // Simulate exceeding water goal to trigger warning
                final currentWater = drinkController.totalWaterToday.value;
                final waterGoal = settingsController.waterDailyGoal.value;

                if (currentWater < waterGoal) {
                  await notificationService.checkWaterWarning(waterGoal + 100);
                  Get.snackbar('Test',
                      'Water warning check triggered (simulated excess)',
                      backgroundColor: Colors.orange, colorText: Colors.white);
                } else {
                  Get.snackbar('Test',
                      'Water goal already exceeded - reset warnings first',
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: const Text('Test Water Warning'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await notificationService.cancelAllNotifications();
                Get.snackbar('Test', 'All notifications cancelled',
                    backgroundColor: Colors.red, colorText: Colors.white);
              },
              child: const Text('Cancel All Notifications'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Instructions:\n'
              '1. Enable notifications in Settings first\n'
              '2. Test morning tip scheduling\n'
              '3. Test warning notifications\n'
              '4. Check notification panel for results',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
