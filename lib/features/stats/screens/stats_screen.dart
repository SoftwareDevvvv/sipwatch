import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/stats_controller.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final StatsController _statsController = Get.put(StatsController());

  @override
  void initState() {
    super.initState();

    // Force refresh data when screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _statsController.updateWeeklyData();
      _statsController.updateMonthlyData();
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
          'Stats',
          style: AppTextStyles.heading2,
        ),
        toolbarHeight: AppDimensions.appBarHeight,
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Weekly consumption card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly consumption (${_statsController.formatDayName(_statsController.getStartOfWeek())} - ${_statsController.formatDayName(_statsController.getEndOfWeek())})',
                        style: const TextStyle(
                          color: Color(0xFF1B365D),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Row(
                        children: [
                          Flexible(
                            child: _buildLegendItem(
                                '💧', 'Water', AppColors.water),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: _buildLegendItem(
                                '🟠', 'Coffee', AppColors.coffee),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: _buildLegendItem(
                                '🔴', 'Alcohol', AppColors.alcohol),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Weekly chart
                      SizedBox(
                        height: 280,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: _statsController.getWeeklyMaxY().toDouble(),
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    final intervals = _statsController
                                        .getWeeklyYAxisIntervals();

                                    // Only show values that are in our calculated intervals
                                    if (intervals.contains(value.toInt())) {
                                      return Text(
                                        '${value.toInt()}ml',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value >= 0 &&
                                        value <
                                            _statsController
                                                .weeklyData.length) {
                                      return Text(
                                        _statsController
                                                .weeklyData[value.toInt()]
                                            ['dayName'],
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: _getWeeklyGridInterval(),
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  color: Color(0xFFEEEEEE),
                                  strokeWidth: 1,
                                );
                              },
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: _getWeeklyBarGroups(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Monthly consumption card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly consumption (${_statsController.getCurrentMonthName()})',
                        style: const TextStyle(
                          color: Color(0xFF1B365D),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Days of month divided into 4 segments',
                        style: TextStyle(
                          color: Color(0xFF1B365D),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Row(
                        children: [
                          Flexible(
                            child: _buildLegendItem(
                                '💧', 'Water', AppColors.water),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: _buildLegendItem(
                                '🟠', 'Coffee', AppColors.coffee),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: _buildLegendItem(
                                '🔴', 'Alcohol', AppColors.alcohol),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Monthly chart
                      SizedBox(
                        height: 280,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: _statsController.getMonthlyMaxY().toDouble(),
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    final intervals = _statsController
                                        .getMonthlyYAxisIntervals();

                                    // Only show values that are in our calculated intervals
                                    if (intervals.contains(value.toInt())) {
                                      return Text(
                                        '${value.toInt()}ml',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value >= 0 &&
                                        value <
                                            _statsController
                                                .monthlyData.length) {
                                      final segment = _statsController
                                          .monthlyData[value.toInt()];
                                      return Text(
                                        'Week ${segment['weekNumber']}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: _getMonthlyGridInterval(),
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  color: Color(0xFFEEEEEE),
                                  strokeWidth: 1,
                                );
                              },
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: _getMonthlyBarGroups(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildLegendItem(String emoji, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/images/drop.svg',
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1B365D),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _getWeeklyBarGroups() {
    final List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < _statsController.weeklyData.length; i++) {
      final dayData = _statsController.weeklyData[i];
      // We don't directly use totalWater here as it's included in totalVolume,
      // but we keep track of all values for clarity
      final int totalCoffee = dayData['totalCoffee'] as int;
      final int totalAlcohol = dayData['totalAlcohol'] as int;
      final int totalVolume = dayData['totalVolume'] as int;

      if (totalVolume == 0) {
        // If no data for this day, show empty bar
        barGroups.add(BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: 0,
              color: AppColors.water,
              width: 20,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ));
        continue;
      }

      // Create a stacked bar with alcohol at bottom, coffee in middle, water on top
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: totalVolume.toDouble(),
            color: AppColors.water,
            width: 20,
            borderRadius: BorderRadius.zero,
            rodStackItems: [
              BarChartRodStackItem(
                  0, totalAlcohol.toDouble(), AppColors.alcohol),
              BarChartRodStackItem(totalAlcohol.toDouble(),
                  (totalAlcohol + totalCoffee).toDouble(), AppColors.coffee),
              BarChartRodStackItem((totalAlcohol + totalCoffee).toDouble(),
                  totalVolume.toDouble(), AppColors.water),
            ],
          ),
        ],
      ));
    }

    return barGroups;
  }

  List<BarChartGroupData> _getMonthlyBarGroups() {
    final List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < _statsController.monthlyData.length; i++) {
      final weekData = _statsController.monthlyData[i];
      // We don't directly use totalWater here as it's included in totalVolume,
      // but we keep track of all values for clarity
      final int totalCoffee = weekData['totalCoffee'] as int;
      final int totalAlcohol = weekData['totalAlcohol'] as int;
      final int totalVolume = weekData['totalVolume'] as int;

      if (totalVolume == 0) {
        // If no data for this week, show empty bar
        barGroups.add(BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: 0,
              color: AppColors.water,
              width: 40,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ));
        continue;
      }

      // Create a stacked bar with alcohol at bottom, coffee in middle, water on top
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: totalVolume.toDouble(),
            color: AppColors.water,
            width: 40,
            borderRadius: BorderRadius.zero,
            rodStackItems: [
              BarChartRodStackItem(
                  0, totalAlcohol.toDouble(), AppColors.alcohol),
              BarChartRodStackItem(totalAlcohol.toDouble(),
                  (totalAlcohol + totalCoffee).toDouble(), AppColors.coffee),
              BarChartRodStackItem((totalAlcohol + totalCoffee).toDouble(),
                  totalVolume.toDouble(), AppColors.water),
            ],
          ),
        ],
      ));
    }

    return barGroups;
  }

  // Helper method to get grid interval for weekly chart
  double _getWeeklyGridInterval() {
    final intervals = _statsController.getWeeklyYAxisIntervals();
    if (intervals.length <= 1) return 100.0;

    // Calculate interval between consecutive values
    return (intervals[1] - intervals[0]).toDouble();
  }

  // Helper method to get grid interval for monthly chart
  double _getMonthlyGridInterval() {
    final intervals = _statsController.getMonthlyYAxisIntervals();
    if (intervals.length <= 1) return 250.0;

    // Calculate interval between consecutive values
    return (intervals[1] - intervals[0]).toDouble();
  }
}
