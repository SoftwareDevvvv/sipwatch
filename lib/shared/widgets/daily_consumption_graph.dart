import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_theme.dart';
import '../../features/home/widgets/body_silhouette_painter.dart';
import '../../features/home/widgets/human_silhouette_fill.dart';

class ConsumptionData {
  final String label;
  final double percentage;
  final Color color;

  const ConsumptionData({
    required this.label,
    required this.percentage,
    required this.color,
  });
}

class DailyConsumptionGraph extends StatelessWidget {
  final double waterPercentage;
  final double coffeePercentage;
  final double alcoholPercentage;
  final String? title;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const DailyConsumptionGraph({
    Key? key,
    required this.waterPercentage,
    required this.coffeePercentage,
    required this.alcoholPercentage,
    this.title,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ConsumptionData> consumptionData = [
      ConsumptionData(
        label: 'Water',
        percentage: waterPercentage,
        color: AppColors.water,
      ),
      ConsumptionData(
        label: 'Coffee',
        percentage: coffeePercentage,
        color: AppColors.coffee,
      ),
      ConsumptionData(
        label: 'Alcohol',
        percentage: alcoholPercentage,
        color: AppColors.alcohol,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        children: [
          // Human body with liquid fill
          // Human body with liquid fill
          SizedBox(
            height: 200, // or any appropriate fixed height
            child: AspectRatio(
              aspectRatio: 1 / 2.459,
              child: CustomPaint(
                painter: BodySilhouettePainter(
                  waterPercentage: waterPercentage,
                  coffeePercentage: coffeePercentage,
                  alcoholPercentage: alcoholPercentage,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingXL),

          // Legend and title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? 'Daily consumption\ngraph',
                  style: AppTextStyles.heading4,
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                ...consumptionData.map((data) => _buildLegendItem(data)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ConsumptionData data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/drop.svg',
            width: AppDimensions.iconL,
            height: AppDimensions.iconL,
            color: data.color,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            data.label,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            '${data.percentage.toStringAsFixed(0)}%',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
