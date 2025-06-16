import 'package:flutter/material.dart';

enum DrinkType { water, coffee, alcohol }

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

  // Helper to get icon for drink type
  static IconData getIconForType(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return Icons.opacity;
      case DrinkType.coffee:
        return Icons.coffee;
      case DrinkType.alcohol:
        return Icons.local_bar;
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
    }
  }
}
