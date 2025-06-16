import 'package:flutter/material.dart';

enum DrinkType { water, coffee, alcohol, other }

class DrinkImage {
  final String id;
  final String path;
  final DrinkType type;
  final bool isAsset;

  DrinkImage({
    required this.id,
    required this.path,
    required this.type,
    this.isAsset = false,
  });

  // Convert DrinkImage to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'type': type.index,
      'isAsset': isAsset,
    };
  }

  // Create a DrinkImage from a JSON Map
  factory DrinkImage.fromJson(Map<String, dynamic> json) {
    return DrinkImage(
      id: json['id'],
      path: json['path'],
      type: DrinkType.values[json['type']],
      isAsset: json['isAsset'],
    );
  }

  // Factory constructor for creating a file image
  factory DrinkImage.file({
    required String id,
    required String path,
    required DrinkType type,
  }) {
    return DrinkImage(
      id: id,
      path: path,
      type: type,
      isAsset: false,
    );
  }

  // Factory constructor for creating a stock asset image
  factory DrinkImage.asset({
    required String id,
    required String path,
    required DrinkType type,
  }) {
    return DrinkImage(
      id: id,
      path: path,
      type: type,
      isAsset: true,
    );
  }

  // Helper to get icon for drink type
  static IconData getIconForType(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return Icons.opacity;
      case DrinkType.coffee:
        return Icons.coffee;
      case DrinkType.alcohol:
        return Icons.local_bar;
      case DrinkType.other:
        return Icons.local_drink;
    }
  }

  // Helper to get color for drink type
  static Color getColorForType(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return const Color(0xFF64B5F6);
      case DrinkType.coffee:
        return const Color(0xFF8D6E63);
      case DrinkType.alcohol:
        return const Color(0xFFBA68C8);
      case DrinkType.other:
        return const Color(0xFF9E9E9E);
    }
  }
}

extension DrinkTypeExtension on DrinkType {
  String get name {
    switch (this) {
      case DrinkType.coffee:
        return 'Coffee';
      case DrinkType.water:
        return 'Water';
      case DrinkType.alcohol:
        return 'Alcohol';
      case DrinkType.other:
        return 'Other';
    }
  }

  Color get color {
    switch (this) {
      case DrinkType.coffee:
        return const Color(0xFF8D6E63);
      case DrinkType.water:
        return const Color(0xFF64B5F6);
      case DrinkType.alcohol:
        return const Color(0xFFE57373);
      case DrinkType.other:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData get icon {
    switch (this) {
      case DrinkType.coffee:
        return Icons.coffee;
      case DrinkType.water:
        return Icons.water_drop;
      case DrinkType.alcohol:
        return Icons.sports_bar;
      case DrinkType.other:
        return Icons.local_drink;
    }
  }

  static DrinkType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'coffee':
        return DrinkType.coffee;
      case 'water':
        return DrinkType.water;
      case 'alcohol':
        return DrinkType.alcohol;
      default:
        return DrinkType.other;
    }
  }
}
