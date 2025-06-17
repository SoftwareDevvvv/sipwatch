import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../features/home/controllers/drink_entry_controller.dart';

class StatsController extends GetxController {
  final DrinkEntryController _drinkEntryController =
      Get.find<DrinkEntryController>();

  // Current week and month
  final Rx<DateTime> currentDate = DateTime.now().obs;

  // Weekly data
  final RxList<Map<String, dynamic>> weeklyData = <Map<String, dynamic>>[].obs;

  // Monthly data
  final RxList<Map<String, dynamic>> monthlyData = <Map<String, dynamic>>[].obs;

  // Store workers to dispose them later
  late List<Worker> _workers;

  @override
  void onInit() {
    super.onInit();
    updateWeeklyData();
    updateMonthlyData();

    // Setup workers to listen for changes in drinks data
    _workers = [
      ever(_drinkEntryController.allDrinks, (_) {
        print("Stats controller: Drinks updated, refreshing stats");
        updateWeeklyData();
        updateMonthlyData();
      }),
    ];
  }

  @override
  void onClose() {
    // Dispose all workers
    for (final worker in _workers) {
      worker.dispose();
    }
    super.onClose();
  }

  // Get the start of the current week (Sunday)
  DateTime getStartOfWeek() {
    final now = currentDate.value;
    return DateTime(now.year, now.month, now.day - now.weekday % 7);
  }

  // Get the end of the current week (Saturday)
  DateTime getEndOfWeek() {
    final startOfWeek = getStartOfWeek();
    return startOfWeek.add(const Duration(days: 6));
  }

  // Get the current month name
  String getCurrentMonthName() {
    return DateFormat('MMMM').format(currentDate.value);
  }

  // Get the start of the current month
  DateTime getStartOfMonth() {
    final now = currentDate.value;
    return DateTime(now.year, now.month, 1);
  }

  // Get the end of the current month
  DateTime getEndOfMonth() {
    final now = currentDate.value;
    return DateTime(now.year, now.month + 1, 0); // Last day of current month
  }

  // Format date as day name (e.g., "Mon")
  String formatDayName(DateTime date) {
    return DateFormat('E').format(date);
  }

  // Update weekly data
  void updateWeeklyData() {
    final startOfWeek = getStartOfWeek();

    weeklyData.clear();

    // Get data for each day of the week
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final stats = _drinkEntryController.calculateStatsForDate(date);
      weeklyData.add({
        'date': date,
        'dayName': formatDayName(date),
        'totalWater': stats['totalWater'] as int? ?? 0,
        'totalCoffee': stats['totalCoffee'] as int? ?? 0,
        'totalAlcohol': stats['totalAlcohol'] as int? ?? 0,
        'totalVolume': stats['totalVolume'] as int? ?? 0,
      });
    }
  } // Update monthly data - divide month into exactly 4 segments

  void updateMonthlyData() {
    final startOfMonth = getStartOfMonth();
    final endOfMonth = getEndOfMonth();

    // Calculate the number of days in the month
    final daysInMonth = endOfMonth.day;

    monthlyData.clear();

    // Create 4 segments, ensuring all days are covered
    List<int> segmentBoundaries = [];

    // Calculate segment boundaries to distribute days evenly
    for (int i = 0; i <= 4; i++) {
      segmentBoundaries.add((i * daysInMonth / 4).round());
    }

    // Ensure the last boundary is exactly the number of days
    segmentBoundaries[4] = daysInMonth;

    // Create 4 segments
    for (int segmentIndex = 0; segmentIndex < 4; segmentIndex++) {
      // Calculate start and end days for this segment (1-based day numbers)
      final segmentStartDay = segmentBoundaries[segmentIndex] + 1;
      final segmentEndDay = segmentBoundaries[segmentIndex + 1];

      // Ensure we don't go beyond the month bounds
      final actualStartDay = segmentStartDay.clamp(1, daysInMonth);
      final actualEndDay = segmentEndDay.clamp(1, daysInMonth);

      // Create date objects for segment boundaries
      final segmentStartDate =
          DateTime(startOfMonth.year, startOfMonth.month, actualStartDay);
      final segmentEndDate =
          DateTime(startOfMonth.year, startOfMonth.month, actualEndDay);

      int totalWater = 0;
      int totalCoffee = 0;
      int totalAlcohol = 0;

      // Sum up data for each day in the segment
      DateTime currentDay = segmentStartDate;
      while (!currentDay.isAfter(segmentEndDate)) {
        final stats = _drinkEntryController.calculateStatsForDate(currentDay);
        totalWater += (stats['totalWater'] as int? ?? 0);
        totalCoffee += (stats['totalCoffee'] as int? ?? 0);
        totalAlcohol += (stats['totalAlcohol'] as int? ?? 0);

        currentDay = currentDay.add(const Duration(days: 1));
      }

      // Week number is segment index + 1
      final weekNumber = segmentIndex + 1;

      monthlyData.add({
        'weekNumber': weekNumber,
        'startDate': segmentStartDate,
        'endDate': segmentEndDate,
        'totalWater': totalWater,
        'totalCoffee': totalCoffee,
        'totalAlcohol': totalAlcohol,
        'totalVolume': totalWater + totalCoffee + totalAlcohol,
        'daysInSegment': actualEndDay - actualStartDay + 1,
      });
    }

    print(
        'Monthly data updated - divided into 4 segments for ${getCurrentMonthName()}:');
    for (final segment in monthlyData) {
      print(
          'Segment ${segment['weekNumber']}: Days ${segment['startDate'].day}-${segment['endDate'].day}, '
          '${segment['daysInSegment']} days, ${segment['totalVolume']} ml');
    }

    // Verify all days are covered
    int totalDaysCovered = 0;
    for (final segment in monthlyData) {
      totalDaysCovered += segment['daysInSegment'] as int;
    }
    print('Total days covered: $totalDaysCovered out of $daysInMonth');
  }

  // Get max Y value for weekly chart
  int getWeeklyMaxY() {
    if (weeklyData.isEmpty) return 900; // Default if no data

    int maxVolume = 0;
    for (final day in weeklyData) {
      final totalVolume = day['totalVolume'] as int;
      if (totalVolume > maxVolume) {
        maxVolume = totalVolume;
      }
    }

    // Round up to nearest hundred for better visualization
    return ((maxVolume / 100).ceil() * 100 + 200).toInt();
  }

  // Get max Y value for monthly chart
  int getMonthlyMaxY() {
    if (monthlyData.isEmpty) return 900; // Default if no data

    int maxVolume = 0;
    for (final week in monthlyData) {
      final totalVolume = week['totalVolume'] as int;
      if (totalVolume > maxVolume) {
        maxVolume = totalVolume;
      }
    }

    // Round up to nearest hundred for better visualization
    return ((maxVolume / 100).ceil() * 100 + 200).toInt();
  }

  // Calculate smart Y-axis intervals for weekly chart based on actual data
  List<int> getWeeklyYAxisIntervals() {
    final maxY = getWeeklyMaxY();

    // If no data, return basic intervals
    if (weeklyData.isEmpty || maxY <= 100) {
      return [0, 250, 500, 750, 1000];
    }

    // Find the actual maximum consumed value (not the chart max)
    int actualMax = 0;
    for (final day in weeklyData) {
      final totalVolume = day['totalVolume'] as int;
      if (totalVolume > actualMax) {
        actualMax = totalVolume;
      }
    }

    // Create smart intervals based on actual consumption
    return _calculateSmartIntervals(actualMax, maxY);
  }

  // Calculate smart Y-axis intervals for monthly chart based on actual data
  List<int> getMonthlyYAxisIntervals() {
    final maxY = getMonthlyMaxY();

    // If no data, return basic intervals
    if (monthlyData.isEmpty || maxY <= 100) {
      return [0, 500, 1000, 1500, 2000];
    }

    // Find the actual maximum consumed value (not the chart max)
    int actualMax = 0;
    for (final week in monthlyData) {
      final totalVolume = week['totalVolume'] as int;
      if (totalVolume > actualMax) {
        actualMax = totalVolume;
      }
    }

    // Create smart intervals based on actual consumption
    return _calculateSmartIntervals(actualMax, maxY);
  }

  // Helper method to calculate smart intervals
  List<int> _calculateSmartIntervals(int actualMax, int chartMax) {
    List<int> intervals = [0]; // Always start with 0

    // If actual max is very small, use small increments
    if (actualMax <= 500) {
      for (int i = 100; i <= chartMax; i += 100) {
        intervals.add(i);
        if (intervals.length >= 6) break; // Limit to 6 intervals max
      }
    }
    // Medium values
    else if (actualMax <= 2000) {
      for (int i = 250; i <= chartMax; i += 250) {
        intervals.add(i);
        if (intervals.length >= 6) break;
      }
    }
    // Large values
    else if (actualMax <= 5000) {
      for (int i = 500; i <= chartMax; i += 500) {
        intervals.add(i);
        if (intervals.length >= 6) break;
      }
    }
    // Very large values
    else {
      for (int i = 1000; i <= chartMax; i += 1000) {
        intervals.add(i);
        if (intervals.length >= 6) break;
      }
    }

    return intervals;
  }
}
