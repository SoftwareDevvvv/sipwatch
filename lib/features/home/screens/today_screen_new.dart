import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/daily_consumption_graph.dart';
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

  @override
  Widget build(BuildContext context) {
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
                    // Container for card - now positioned to fill entire card area
                    Container(
                      width: double.infinity,
                      height:
                          130, // Added explicit height to ensure full coverage
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.cardBorder, width: 2),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusL),
                        color: AppColors.cardBackground,
                      ),
                    ),

                    // Wave SVG at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/images/wave-blue.svg',
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Content on top of everything
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Total today',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingS),
                              Text(
                                '${_getTotalVolume()} ml',
                                style: AppTextStyles.displayLarge,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '% Of Daily Norm',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingS),
                              Text(
                                '${_getDailyNormPercentage()}%',
                                style: AppTextStyles.displayLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingL),

                // Daily consumption graph
                DailyConsumptionGraph(
                  waterPercentage: _drinkEntryController.getWaterPercentage(),
                  coffeePercentage: _drinkEntryController.getCoffeePercentage(),
                  alcoholPercentage:
                      _drinkEntryController.getAlcoholPercentage(),
                ),
                const SizedBox(height: AppDimensions.paddingL),

                // Cups drunk section
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

          // Drink name, time, and details
          Expanded(
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
                      ),
                    ),
                    Text(
                      drink.time,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                // Volume and caffeine on the second row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${drink.volume}ml',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Text(
                      _getUniqueFactorText(drink),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppDimensions.paddingM),

          // Action buttons in a row
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
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(50, 36),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingS),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                ),
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
                  minimumSize: const Size(36, 36),
                  padding: const EdgeInsets.all(0),
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
        iconData = Icons.local_bar;
        break;
      case DrinkType.other:
      default:
        iconData = Icons.local_drink;
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
        return AppColors.alcohol;
      case DrinkType.other:
      default:
        return AppColors.primary;
    }
  }

  // Helper method to get the unique factor text based on drink type
  String _getUniqueFactorText(DrinkEntry drink) {
    switch (drink.type) {
      case DrinkType.coffee:
        return drink.caffeine != null
            ? '${drink.caffeine} mg Caffeine'
            : 'No caffeine info';
      case DrinkType.alcohol:
        return drink.alcoholPercentage != null
            ? '${drink.alcoholPercentage?.toStringAsFixed(1)}% Alcohol'
            : 'No alcohol info';
      case DrinkType.water:
        return 'Water';
      case DrinkType.other:
      default:
        return 'Other drink';
    }
  }

  // Calculate total volume of all drinks today
  int _getTotalVolume() {
    return _drinkEntryController.totalWaterToday.value +
        _drinkEntryController.totalCoffeeToday.value +
        _drinkEntryController.totalAlcoholToday.value;
  }

  // Calculate percentage of daily norm (hardcoded to 2000ml for now)
  int _getDailyNormPercentage() {
    const dailyNorm = 2000; // ml
    final totalVolume = _getTotalVolume();
    return totalVolume > 0 ? ((totalVolume / dailyNorm) * 100).round() : 0;
  }
}
