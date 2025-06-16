import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/home/controllers/drink_entry_controller.dart';
import '../../../features/home/controllers/drink_image_controller.dart';
import '../../../features/home/models/drink_entry.dart';
import '../../../features/home/models/drink_image.dart';

class FluidAdditionScreen extends StatefulWidget {
  final DrinkEntry? editDrink;

  const FluidAdditionScreen({
    super.key,
    this.editDrink,
  });

  @override
  State<FluidAdditionScreen> createState() => _FluidAdditionScreenState();
}

class _FluidAdditionScreenState extends State<FluidAdditionScreen> {
  // Helper to convert string drink type to enum
  DrinkType _getDrinkTypeFromString(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'coffee':
        return DrinkType.coffee;
      case 'water':
        return DrinkType.water;
      case 'alcohol':
      default:
        return DrinkType.alcohol;
    }
  }

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _uniqueFactorAmountController = TextEditingController();
  final _commentsController = TextEditingController();

  late String selectedUniqueFactor = 'Caffeine';
  late DrinkType selectedDrinkType = DrinkType.coffee;
  late TimeOfDay selectedTime = TimeOfDay.now();

  // Controllers
  final DrinkEntryController _drinkEntryController =
      Get.find<DrinkEntryController>();
  final DrinkImageController _drinkImageController =
      Get.find<DrinkImageController>();

  bool get isEditMode => widget.editDrink != null;
  final List<String> uniqueFactorOptions = [
    'Caffeine',
    'Alcohol',
  ];
  final List<String> drinkTypes = [
    'Coffee',
    'Water',
    'Alcohol',
  ];

  @override
  void initState() {
    super.initState();

    // If we're editing a drink, populate the form
    if (isEditMode) {
      final drink = widget.editDrink!;
      _nameController.text = drink.name;
      _amountController.text = drink.volume.toString();

      if (drink.caffeine != null) {
        _uniqueFactorAmountController.text = drink.caffeine.toString();
        selectedUniqueFactor = 'Caffeine';
      } else if (drink.alcoholPercentage != null) {
        _uniqueFactorAmountController.text = drink.alcoholPercentage.toString();
        selectedUniqueFactor = 'Alcohol';
      }

      selectedDrinkType = drink.type;

      // Parse the time string (format HH:MM)
      final timeParts = drink.time.split(':');
      if (timeParts.length == 2) {
        final hour = int.tryParse(timeParts[0]) ?? TimeOfDay.now().hour;
        final minute = int.tryParse(timeParts[1]) ?? TimeOfDay.now().minute;
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      }

      _commentsController.text = drink.comments ?? '';

      // Set selected image if one exists
      if (drink.imageId != null && drink.imageId!.isNotEmpty) {
        _drinkImageController.selectImage(drink.imageId!);
      } else {
        // Try to select a default image for this drink type
        _selectDefaultImageForType(selectedDrinkType);
      }
    } else {
      _selectDefaultImageForType(selectedDrinkType);
    }
  }

  void _selectDefaultImageForType(DrinkType type) {
    // Instead of getting images by type, just select the first available image if any
    if (_drinkImageController.drinkImages.isNotEmpty) {
      _drinkImageController
          .selectImage(_drinkImageController.drinkImages.first.id);
    } else {
      // Reset the selected image id if no images are available
      _drinkImageController.selectedImageId.value = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEditMode ? 'Fluid Edit' : 'Fluid addition',
                    style: AppTextStyles.heading3),
                const SizedBox(
                    height: AppDimensions
                        .paddingL), // Conditional Row 1: Name of drink & Unique factor (hidden for Water)
                if (selectedDrinkType != DrinkType.water) ...[
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField('Name of Drink',
                              _nameController, 'Enter drink name')),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                          child: _buildDropdownField(
                              'Unique Factor',
                              selectedUniqueFactor,
                              uniqueFactorOptions, (value) {
                        setState(() {
                          selectedUniqueFactor = value!;
                        });
                      })),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                ],

                // Row 2: Drink Type & Amount
                Row(
                  children: [
                    Expanded(
                        child: _buildDropdownField(
                            'Drink Type', selectedDrinkType.name, drinkTypes,
                            (value) {
                      setState(() {
                        selectedDrinkType = _getDrinkTypeFromString(value!);
                      });
                    })),
                    const SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                        child: _buildTextField(
                            'Amount (ml)', _amountController, 'Enter amount')),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),

                // Row 3: Amount of unique factor & Time (unique factor hidden for Water)
                Row(
                  children: [
                    if (selectedDrinkType != DrinkType.water)
                      Expanded(
                          child: _buildTextField('Amount of unique factor',
                              _uniqueFactorAmountController, 'Enter amount')),
                    if (selectedDrinkType != DrinkType.water)
                      const SizedBox(width: AppDimensions.paddingM),
                    Expanded(child: _buildTimeField()),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),

                // Comments
                _buildTextField(
                    'Comments', _commentsController, 'Add your comments here'),
                const SizedBox(height: AppDimensions.paddingL), // Drink Photos
                Text('Select Drink Photo Or Add Custom',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Color(0xFF00214D))),
                const SizedBox(height: AppDimensions.paddingM),

                // Grid layout for drink images
                _buildDrinkImagesGrid(),
                const SizedBox(height: AppDimensions.paddingXL),

                // Add New Drink Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveDrink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingM,
                        ),
                      ),
                      child: Text(
                        isEditMode ? 'Edit fluid' : '+ Add New Drink',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textButtonColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String currentValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF00214D))),
        const SizedBox(height: AppDimensions.paddingS),
        DropdownButtonFormField<String>(
          value: currentValue,
          onChanged: onChanged,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
          ),
          dropdownColor: AppColors.surfaceVariant,
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint) {
    // Check if this is a numerical field (amount fields)
    bool isNumerical = label.toLowerCase().contains('amount');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF00214D))),
        const SizedBox(height: AppDimensions.paddingS),
        TextFormField(
          controller: controller,
          maxLines: label == 'Comments' ? 4 : 1,
          keyboardType: isNumerical ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.inputColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Time',
            style: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF00214D))),
        const SizedBox(height: AppDimensions.paddingS),
        GestureDetector(
          onTap: _showTimePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.inputColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime.format(context),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(Icons.access_time, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: DateTime(
              2024,
              1,
              1,
              selectedTime.hour,
              selectedTime.minute,
            ),
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime dateTime) {
              setState(() {
                selectedTime = TimeOfDay(
                  hour: dateTime.hour,
                  minute: dateTime.minute,
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDrinkImagesGrid() {
    return Obx(() {
      // Get all images instead of filtering by type
      final List<DrinkImage> allImages = _drinkImageController.drinkImages;

      // Create a list of all items (images + add button)
      final List<Widget> allItems = [];

      // Add a message if there are no images
      if (allImages.isEmpty) {
        allItems.add(
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No images available. Add your first drink image!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      } else {
        // Add drink images
        for (final image in allImages) {
          final bool selected =
              image.id == _drinkImageController.selectedImageId.value;
          allItems.add(_buildDrinkImageWidget(image, selected: selected));
        }
      }

      // Add the add button at the end
      allItems.add(_buildAddButton());

      return Wrap(
        spacing: AppDimensions.paddingM, // Horizontal spacing between items
        runSpacing: AppDimensions.paddingM, // Vertical spacing between rows
        children: allItems,
      );
    });
  }

  Widget _buildDrinkImageWidget(DrinkImage image, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        // Set the selected image and update the UI
        _drinkImageController.selectImage(image.id);
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Image.file(File(image.path),
                width: 85, height: 85, fit: BoxFit.cover),
          ),
          if (selected)
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.textButtonColor)),
              child: const Icon(
                Icons.check,
                color: AppColors.primaryDark,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showImageSourceModal,
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 28, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusXL),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: AppDimensions.paddingM),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: Text(
                    'Add Drink Photo',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Options
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL),
                  child: Column(
                    children: [
                      _buildImageSourceOption(
                        icon: Icons.photo_library,
                        title: 'Choose from Gallery',
                        subtitle: 'Select an existing photo',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromGallery();
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      _buildImageSourceOption(
                        icon: Icons.camera_alt,
                        title: 'Take Photo',
                        subtitle: 'Use camera to take a new photo',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromCamera();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingXL),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.inputColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textHint,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _pickImageFromGallery() async {
    final image =
        await _drinkImageController.addImageFromGallery(selectedDrinkType);
    if (image != null) {
      // The image was added and selected automatically in the controller
      setState(() {});
    }
  }

  void _pickImageFromCamera() async {
    final image =
        await _drinkImageController.addImageFromCamera(selectedDrinkType);
    if (image != null) {
      // The image was added and selected automatically in the controller
      setState(() {});
    }
  }

  void _saveDrink() {
    // Validate input
    if (_amountController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter an amount',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Get the volume value
    final volume = int.tryParse(_amountController.text);
    if (volume == null || volume <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount',
          snackPosition: SnackPosition.BOTTOM);
      return;
    } // Get the selected image (if any)
    String? imageId = null;
    if (_drinkImageController.drinkImages.isNotEmpty &&
        _drinkImageController.selectedImageId.value.isNotEmpty) {
      imageId = _drinkImageController.selectedImageId.value;
    }

    // Process additional fields based on drink type
    int? caffeine;
    double? alcoholPercentage;

    if (selectedDrinkType != DrinkType.water &&
        _uniqueFactorAmountController.text.isNotEmpty) {
      if (selectedUniqueFactor == 'Caffeine') {
        caffeine = int.tryParse(_uniqueFactorAmountController.text);
      } else if (selectedUniqueFactor == 'Alcohol') {
        alcoholPercentage = double.tryParse(_uniqueFactorAmountController.text);
      }
    }

    // Create the time string (format HH:MM)
    final timeStr =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}'; // Create or update the drink entry
    final drink = DrinkEntry(
      id: isEditMode ? widget.editDrink!.id : const Uuid().v4(),
      name: selectedDrinkType == DrinkType.water
          ? "Water"
          : (_nameController.text.isEmpty
              ? selectedDrinkType.name
              : _nameController.text),
      volume: volume,
      type: selectedDrinkType,
      time: timeStr,
      date: DateTime.now(), // Use DateTime instead of String
      caffeine: caffeine,
      alcoholPercentage: alcoholPercentage,
      comments:
          _commentsController.text.isEmpty ? null : _commentsController.text,
      imageId: imageId,
    );

    // Save to the controller
    if (isEditMode) {
      _drinkEntryController.updateDrink(drink);
      Get.back();
      Get.snackbar('Success', 'Drink updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      _drinkEntryController.addDrink(drink);
      Get.back();
      Get.snackbar('Success', 'Drink added successfully',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Delete an image}
}
