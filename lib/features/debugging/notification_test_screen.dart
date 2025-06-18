import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme/app_theme.dart';
import '../settings/controllers/settings_controller.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({Key? key}) : super(key: key);

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Notification Testing',
          style: AppTextStyles.heading2,
        ),
        toolbarHeight: AppDimensions.appBarHeight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Settings status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Settings',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Column(
                        children: [
                          _buildSettingRow('Daily Notifications',
                              _settingsController.dailyNotification.value),
                          _buildSettingRow('Morning Tips',
                              _settingsController.morningTips.value),
                          _buildSettingRow('Water Warning',
                              _settingsController.waterWarning.value),
                          _buildSettingRow('Coffee Warning',
                              _settingsController.coffeeWarning.value),
                          _buildSettingRow('Alcohol Warning',
                              _settingsController.alcoholWarning.value),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Test buttons
            Text(
              'Test Notifications',
              style: AppTextStyles.heading4,
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await _notificationService.showTestNotification(
                  'Test Notification',
                  'This is a test notification to check if notifications are working!',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test notification sent!')),
                );
              },
              child: const Text('Send Test Notification'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await _notificationService.showTestMorningTip();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test morning tip sent!')),
                );
              },
              child: const Text('Send Test Morning Tip'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await _notificationService.scheduleTestMorningTipIn5Seconds();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Test morning tip scheduled in 5 seconds!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Schedule Test Tip (5 seconds)'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await _notificationService.scheduleDailyMorningTip();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Morning tip scheduled!')),
                );
              },
              child: const Text('Schedule Morning Tips'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await _notificationService.checkPendingNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Check console for pending notifications')),
                );
              },
              child: const Text('Check Pending Notifications'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await _notificationService.cancelAllNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All notifications cancelled!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonDanger,
              ),
              child: const Text('Cancel All Notifications'),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. First enable "Morning Tips" in Settings\n'
                    '2. Use "Send Test Morning Tip" to verify notifications work immediately\n'
                    '3. Use "Schedule Morning Tips" to set up daily 8 AM notifications\n'
                    '4. Check pending notifications to see if they are scheduled\n'
                    '5. Check your device notification settings if tests fail',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );
  }
}
