import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sipwatch/core/theme/app_theme.dart';

import '../../../shared/widgets/daily_consumption_graph.dart';
import '../../../shared/widgets/custom_month_year_picker.dart';
import '../../../features/home/controllers/drink_entry_controller.dart';
import '../../../features/settings/controllers/settings_controller.dart';
import '../../../features/home/models/drink_entry.dart';
import '../../../features/home/models/drink_image.dart' show DrinkType;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Use reactive (Rx) variables for state that affects UI
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> currentMonth =
      DateTime(DateTime.now().year, DateTime.now().month).obs;

  // Controllers
  final DrinkEntryController _drinkEntryController =
      Get.find<DrinkEntryController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  final List<String> dayNames = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  final FixedExtentScrollController _monthScrollController =
      FixedExtentScrollController(initialItem: 3);

  @override
  void initState() {
    super.initState();

    // Set initial dates to today
    selectedDate.value = DateTime.now();
    currentMonth.value = DateTime(DateTime.now().year, DateTime.now().month);

    // Add a listener to the selectedDate to update UI when it changes
    ever(selectedDate, (_) {
      print("Selected date changed to: ${selectedDate.value}");
      // This is automatically handled by Obx in the build method
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Calendar',
          style: AppTextStyles.heading2,
        ),
        toolbarHeight: AppDimensions.appBarHeight,
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Section - Stats Cards
                _buildStatsSection(),
                const SizedBox(height: 16),

                Text(
                  '${selectedDate.value.day} ${_getMonthName(selectedDate.value.month)} ${selectedDate.value.year}',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Second Section - Calendar
                _buildCalendarWithMonthPicker(),

                const SizedBox(height: 16),

                // Third Section - Daily Consumption Graph
                _buildDailyConsumptionGraph(),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          )),
    );
  }

  Widget _buildStatsSection() {
    // Get the most consumed drink type for the selected date
    final mostConsumedType =
        _drinkEntryController.getMostConsumedTypeForDate(selectedDate.value);

    // Get the daily norm percentage for the selected date
    final normPercentage = _drinkEntryController.getDailyNormPercentageForDate(
        selectedDate.value, _settingsController.waterDailyGoal.value);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Most drunk',
            drinkType: mostConsumedType,
            color: AppColors.calendarCardColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: '% of normal',
            value: '$normPercentage%',
            color: AppColors.calendarCardColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    String? value,
    DrinkType? drinkType,
    required Color color,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Wave SVG at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/wave-red.svg',
              fit: BoxFit.contain,
            ),
          ),

          // Content on top of the wave
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.calendarTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                if (value != null)
                  Center(
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.iconForegroundColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (drinkType != null)
                  Center(
                    child: _buildDrinkTypeIcon(drinkType),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get the appropriate icon for drink type
  Widget _buildDrinkTypeIcon(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return Icon(
          Icons.water_drop,
          color: AppColors.iconForegroundColor,
          size: 55,
        );
      case DrinkType.coffee:
        return Icon(
          Icons.coffee,
          color: AppColors.iconForegroundColor,
          size: 55,
        );
      case DrinkType.alcohol:
      default:
        return SvgPicture.asset(
          "assets/images/alcohol-glasses.svg",
          width: 55,
          height: 55,
          color: AppColors.iconForegroundColor,
        );
    }
  }

  Widget _buildCalendarWithMonthPicker() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Calendar Section
              Expanded(
                flex: 5,
                child: Center(
                  child: _buildCalendar(),
                ),
              ),
              const SizedBox(width: 20),
              // Month Picker Section (Tappable)
              SizedBox(
                width: 55,
                child: _buildInteractiveMonthPicker(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  Widget _buildCalendar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Day headers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Row(
            children: dayNames
                .map((day) => Expanded(
                      child: Container(
                        height: 28,
                        alignment: Alignment.center,
                        child: Text(
                          day,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 8),

        // Calendar Grid
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          height: 220,
          child: _buildCalendarGrid(),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(currentMonth.value.year, currentMonth.value.month, 1);
    final startDate =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.9, // Slightly taller cells for better proportion
        crossAxisSpacing: 2,
        mainAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isCurrentMonth = date.month == currentMonth.value.month;
        final isSelected = date.day == selectedDate.value.day &&
            date.month == selectedDate.value.month &&
            date.year == selectedDate.value.year;
        return GestureDetector(
          onTap: () {
            // Update the selected date
            selectedDate.value = date;

            // If the month changed, update the current month as well
            if (date.month != currentMonth.value.month) {
              currentMonth.value = DateTime(date.year, date.month);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.buttonPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              border: isSelected
                  ? Border.all(color: AppColors.buttonPrimary, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractiveMonthPicker() {
    // Get current month index for display
    final currentMonthIndex = currentMonth.value.month; // 1-12
    final displayMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return GestureDetector(
      onTap: () async {
        final pickedDate = await showCustomMonthYearPicker(
          context,
          currentMonth.value,
        );

        if (pickedDate != null) {
          // Update current month
          currentMonth.value = pickedDate;

          // Update selected date to first day of new month if needed
          if (selectedDate.value.month != pickedDate.month ||
              selectedDate.value.year != pickedDate.year) {
            selectedDate.value = DateTime(pickedDate.year, pickedDate.month, 1);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Center(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                  Colors.black,
                  Colors.black,
                  Colors.transparent,
                ],
                stops: [0.0, 0.15, 0.4, 0.85, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: SizedBox(
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display months around current month for visual effect
                  for (int i = -2; i <= 2; i++)
                    Container(
                      height: 32,
                      alignment: Alignment.center,
                      child: Text(
                        displayMonths[
                            ((currentMonthIndex - 1 + i) % 12 + 12) % 12],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: i == 0
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                          fontSize: i == 0 ? 16 : 14,
                          fontWeight:
                              i == 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyConsumptionGraph() {
    // Get the percentages for the selected date
    final percentages =
        _drinkEntryController.getPercentagesForDate(selectedDate.value);

    // Print debug information
    print('Daily consumption graph percentages:');
    print('Water: ${percentages['water']}%');
    print('Coffee: ${percentages['coffee']}%');
    print('Alcohol: ${percentages['alcohol']}%');

    // The DailyConsumptionGraph expects values as percentages (0-100)
    return DailyConsumptionGraph(
      waterPercentage: percentages['water']!, // Already a percentage
      coffeePercentage: percentages['coffee']!,
      alcoholPercentage: percentages['alcohol']!,
      title: 'Daily Consumption\ngraph',
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      backgroundColor: AppColors.cardBackground,
    );
  }

  @override
  void dispose() {
    _monthScrollController.dispose();
    // No need to dispose Rx variables or workers created with 'ever'
    // as they are automatically managed by GetX
    super.dispose();
  }
}
