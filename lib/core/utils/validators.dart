import '../constants/app_constants.dart';

class Validators {
  // Volume validation
  static String? validateVolume(String? value) {
    if (value == null || value.isEmpty) {
      return 'Volume is required';
    }

    final volume = int.tryParse(value);
    if (volume == null) {
      return 'Please enter a valid number';
    }

    if (volume < AppConstants.minVolumeML) {
      return 'Volume must be at least ${AppConstants.minVolumeML}ml';
    }

    if (volume > AppConstants.maxVolumeML) {
      return 'Volume cannot exceed ${AppConstants.maxVolumeML}ml';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.trim().isEmpty) {
      return 'Name cannot be empty';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Name cannot exceed 50 characters';
    }

    return null;
  }

  // Weight validation
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }

    if (weight < 20) {
      return 'Weight must be at least 20kg';
    }

    if (weight > 300) {
      return 'Weight cannot exceed 300kg';
    }

    return null;
  }

  // Caffeine validation
  static String? validateCaffeine(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Caffeine is optional
    }

    final caffeine = int.tryParse(value);
    if (caffeine == null) {
      return 'Please enter a valid number';
    }

    if (caffeine < 0) {
      return 'Caffeine cannot be negative';
    }

    if (caffeine > 1000) {
      return 'Caffeine seems too high (max 1000mg)';
    }

    return null;
  }

  // Alcohol percentage validation
  static String? validateAlcoholPercentage(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Alcohol percentage is optional
    }

    final percentage = double.tryParse(value);
    if (percentage == null) {
      return 'Please enter a valid percentage';
    }

    if (percentage < 0) {
      return 'Alcohol percentage cannot be negative';
    }

    if (percentage > 100) {
      return 'Alcohol percentage cannot exceed 100%';
    }

    return null;
  }
}
