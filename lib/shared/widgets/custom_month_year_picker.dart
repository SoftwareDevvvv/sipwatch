import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_theme.dart';

class CustomMonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const CustomMonthYearPicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  State<CustomMonthYearPicker> createState() => _CustomMonthYearPickerState();
}

class _CustomMonthYearPickerState extends State<CustomMonthYearPicker> {
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;
  late int selectedMonth;
  late int selectedYear;

  final List<String> months = [
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

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;

    _monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    _yearController = FixedExtentScrollController(
      initialItem: selectedYear - 2020, // Starting from 2020
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _onSelectionChanged() {
    final newDate = DateTime(selectedYear, selectedMonth);
    widget.onDateChanged(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  'Select Date',
                  style: AppTextStyles.heading4,
                ),
                TextButton(
                  onPressed: () {
                    _onSelectionChanged();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Done',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin:
                const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          ),

          // Pickers
          Expanded(
            child: Row(
              children: [
                // Month Picker
                Expanded(
                  child: _buildCupertinoPicker(
                    controller: _monthController,
                    items: months,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMonth = index + 1;
                      });
                    },
                  ),
                ),

                // Separator
                Container(
                  width: 1,
                  height: 100,
                ),

                // Year Picker
                Expanded(
                  child: _buildCupertinoPicker(
                    controller: _yearController,
                    items:
                        List.generate(20, (index) => (2020 + index).toString()),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = 2020 + index;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoPicker({
    required FixedExtentScrollController controller,
    required List<String> items,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: 40,
      backgroundColor: Colors.transparent,
      onSelectedItemChanged: onSelectedItemChanged,
      children: items
          .map((item) => Center(
                child: Text(
                  item,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 18,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// Helper function to show the picker
Future<DateTime?> showCustomMonthYearPicker(
  BuildContext context,
  DateTime initialDate,
) async {
  DateTime? selectedDate;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return CustomMonthYearPicker(
        initialDate: initialDate,
        onDateChanged: (date) {
          selectedDate = date;
        },
      );
    },
  );

  return selectedDate;
}
