import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/daily_consumption_graph.dart';
import '../../../features/settings/controllers/settings_controller.dart';
import '../../add_fluid/screens/add_fluid_screen.dart';
import '../controllers/drink_entry_controller.dart';
import '../controllers/drink_image_controller.dart';
import '../models/drink_entry.dart';
import '../models/drink_image.dart';

class TodayScreen extends StatefulWidget {
  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final DrinkEntryController _drinkEntryController =
      Get.find<DrinkEntryController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  // Store the worker so we can dispose it properly
  late Worker _waterDailyGoalWorker;

  @override
  void initState() {
    super.initState();

    // Add a worker to the waterDailyGoal value to update the UI when it changes
    // Using ever instead of listen gives us a Worker we can dispose
    _waterDailyGoalWorker = ever(_settingsController.waterDailyGoal, (_) {
      // Only call setState if the widget is still mounted
      if (mounted) {
        setState(() {
          // This will trigger a rebuild when the waterDailyGoal changes
          print(
              "Water daily goal changed to: ${_settingsController.waterDailyGoal.value} ml");
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose the worker when the widget is disposed
    _waterDailyGoalWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Print debug info to console
    print("DEBUG - Today Screen Build");
    print(
        "Settings Controller Water Daily Goal: ${_settingsController.waterDailyGoal.value} ml");
    print("Total Volume: ${_getTotalVolume()} ml");
    print("Percentage: ${_getDailyNormPercentage()}%");

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Today',
          style: AppTextStyles.heading2,
        ),
        toolbarHeight: AppDimensions.appBarHeight,
      ),
      body: Obx(() => SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total consumption card
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Container for card
                    Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusL),
                        color: _getDailyNormPercentage() > 100
                            ? AppColors.calendarCardColor
                            : AppColors.cardBackground,
                      ),
                    ),

                    // Wave SVG at the bottom - choose based on consumption
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        _getDailyNormPercentage() > 100
                            ? 'assets/images/wave-red-today.svg'
                            : 'assets/images/wave-blue.svg',
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Gradient at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _getDailyNormPercentage() > 100
                                ? [
                                    const Color(0xFFBC2A2A),
                                    const Color(0xFFBC2A2A)
                                  ]
                                : [
                                    const Color(0xFF2A92BC),
                                    const Color(0xFF2A92BC)
                                  ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(AppDimensions.radiusL),
                            bottomRight: Radius.circular(AppDimensions.radiusL),
                          ),
                        ),
                      ),
                    ),

                    // Content on top of everything
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Total today',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: _getDailyNormPercentage() < 100
                                        ? AppColors.textSecondary
                                        : AppColors.calendarTextColor,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingS),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${_getTotalVolume()} ml',
                                    style: AppTextStyles.displayLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '% Of Daily Norm',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: _getDailyNormPercentage() < 100
                                        ? AppColors.textSecondary
                                        : AppColors.calendarTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingS),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${_getDailyNormPercentage()}%',
                                    style: AppTextStyles.displayLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: AppDimensions.paddingL), // Daily consumption graph
                DailyConsumptionGraph(
                  waterPercentage: _drinkEntryController.getWaterPercentage(),
                  coffeePercentage: _drinkEntryController.getCoffeePercentage(),
                  alcoholPercentage:
                      _drinkEntryController.getAlcoholPercentage(),
                ),
                const SizedBox(
                    height: AppDimensions.paddingL), // Cups drunk section
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cups drunk',
                        style: AppTextStyles.heading3,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // navigate to FluidAddtionScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FluidAdditionScreen(),
                            ),
                          );
                        },
                        child: Text(
                          '+ New Drink',
                        ),
                      ),
                    ]),
                const SizedBox(height: AppDimensions.paddingM),

                // Drinks list
                if (_drinkEntryController.todayDrinks.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No drinks added yet today',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ..._drinkEntryController.todayDrinks
                      .map((drink) => _buildDrinkCard(drink))
                      .toList(),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          )),
    );
  }

  Widget _buildDrinkCard(DrinkEntry drink) {
    final DrinkImageController imageController =
        Get.find<DrinkImageController>();

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        children: [
          // Drink image or fallback icon
          drink.imageId != null && drink.imageId!.isNotEmpty
              ? Container(
                  width: AppDimensions.iconL,
                  height: AppDimensions.iconL,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Builder(
                    builder: (context) {
                      final drinkImage =
                          imageController.getImageById(drink.imageId!);
                      if (drinkImage != null) {
                        return Image.file(
                          File(drinkImage.path),
                          fit: BoxFit.cover,
                          width: AppDimensions.iconL,
                          height: AppDimensions.iconL,
                        );
                      } else {
                        // Fallback if image not found
                        return _buildDrinkTypeIcon(drink.type);
                      }
                    },
                  ),
                )
              : Container(
                  width: AppDimensions.iconL,
                  height: AppDimensions.iconL,
                  decoration: BoxDecoration(
                    color: _getDrinkTypeColor(drink.type),
                    shape: BoxShape.circle,
                  ),
                  child: _buildDrinkTypeIcon(drink.type),
                ),
          const SizedBox(width: AppDimensions.paddingS),

          // Content group: image, title, amount, time, unique factor
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and time on the same row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        drink.name,
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingXS),
                    Flexible(
                      child: Text(
                        drink.time,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Volume and unique factor on the second row
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${drink.volume}ml',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Only show unique factor text if it's not empty
                    if (_getUniqueFactorText(drink).isNotEmpty) ...[
                      const SizedBox(width: AppDimensions.paddingXS),
                      Flexible(
                        child: Text(
                          _getUniqueFactorText(drink),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingXS),

          // Action buttons group
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Edit functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FluidAdditionScreen(editDrink: drink),
                    ),
                  );
                },
                child: const Text('Edit'),
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              ElevatedButton(
                onPressed: () {
                  // Delete functionality
                  _drinkEntryController.deleteDrink(drink.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonDanger,
                  foregroundColor: AppColors.dangerIcon,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(36, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                ),
                child: const Icon(Icons.delete, size: AppDimensions.iconS),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Calculate total volume of all drinks today
  int _getTotalVolume() {
    final totalWater = _drinkEntryController.totalWaterToday.value;
    final totalCoffee = _drinkEntryController.totalCoffeeToday.value;
    final totalAlcohol = _drinkEntryController.totalAlcoholToday.value;
    final total = totalWater + totalCoffee + totalAlcohol;
    print('Debug - Volume Breakdown:');
    print('Water: $totalWater ml');
    print('Coffee: $totalCoffee ml');
    print('Alcohol: $totalAlcohol ml');
    print('Total: $total ml');
    return total;
  } // Calculate percentage of daily norm from settings

  int _getDailyNormPercentage() {
    // Get daily water goal from settings - ensure we're using the latest value
    final dailyNorm = _settingsController.waterDailyGoal.value;

    if (dailyNorm <= 0) {
      print('Error: Invalid daily water goal: $dailyNorm ml');
      return 0; // Can't calculate percentage with invalid goal
    }

    final totalVolume = _getTotalVolume();
    final percentage =
        totalVolume > 0 ? ((totalVolume / dailyNorm) * 100).round() : 0;

    print('Debug - Daily Norm Calculation:');
    print('Total volume: $totalVolume ml');
    print('Daily goal: $dailyNorm ml');
    print('Percentage: $percentage%');

    return percentage;
  }

  // Helper method to get appropriate icon for drink type
  Widget _buildDrinkTypeIcon(DrinkType type) {
    IconData iconData;
    switch (type) {
      case DrinkType.water:
        iconData = Icons.water_drop;
        break;
      case DrinkType.coffee:
        iconData = Icons.coffee;
        break;
      case DrinkType.alcohol:
      default:
        iconData = Icons.local_bar;
        break;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: AppDimensions.iconS,
    );
  }

  // Helper method to get color for drink type
  Color _getDrinkTypeColor(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return AppColors.water;
      case DrinkType.coffee:
        return AppColors.coffee;
      case DrinkType.alcohol:
      default:
        return AppColors.alcohol;
    }
  } // Helper method to get the unique factor text based on drink type

  String _getUniqueFactorText(DrinkEntry drink) {
    switch (drink.type) {
      case DrinkType.coffee:
        return drink.caffeine != null
            ? '${drink.caffeine} mg Caffeine'
            : 'No caffeine info';
      case DrinkType.alcohol:
        return drink.alcoholPercentage != null
            ? '${drink.alcoholPercentage?.toStringAsFixed(1)}% alcohol'
            : '';
      case DrinkType.water:
      default:
        return ''; // No text for water
    }
  }
}
