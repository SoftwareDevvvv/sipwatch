import 'package:uuid/uuid.dart';
import 'drink_image.dart';

class DrinkEntry {
  final String id;
  String name;
  int volume; // in milliliters
  int? caffeine; // in milligrams, null if not applicable
  double? alcoholPercentage; // as a percentage, null if not applicable
  String time; // store as a string in format HH:MM
  DateTime date; // to track which day the drink was consumed
  DrinkType type;
  String? comments;
  String? imageId; // The ID of the associated image

  DrinkEntry({
    String? id,
    required this.name,
    required this.volume,
    this.caffeine,
    this.alcoholPercentage,
    required this.time,
    DateTime? date,
    required this.type,
    this.comments,
    this.imageId,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  // Convert DrinkEntry to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'volume': volume,
      'caffeine': caffeine,
      'alcoholPercentage': alcoholPercentage,
      'time': time,
      'date': date.toIso8601String(),
      'type': type.index,
      'comments': comments,
      'imageId': imageId,
    };
  }

  // Create a DrinkEntry from a JSON Map
  factory DrinkEntry.fromJson(Map<String, dynamic> json) {
    return DrinkEntry(
      id: json['id'],
      name: json['name'],
      volume: json['volume'],
      caffeine: json['caffeine'],
      alcoholPercentage: json['alcoholPercentage'],
      time: json['time'],
      date: DateTime.parse(json['date']),
      type: DrinkType.values[json['type']],
      comments: json['comments'],
      imageId: json['imageId'],
    );
  } // Helper to calculate unique factor amount text
  String get uniqueFactorText {
    switch (type) {
      case DrinkType.coffee:
        return caffeine != null ? '$caffeine mg caffeine' : 'No caffeine info';
      case DrinkType.alcohol:
        return alcoholPercentage != null
            ? '${alcoholPercentage!.toStringAsFixed(1)}% alcohol'
            : '';
      case DrinkType.water:
      default:
        return '';
    }
  }

  // Helper to get unique factor amount value (for sorting, etc.)
  num? get uniqueFactorValue {
    switch (type) {
      case DrinkType.coffee:
        return caffeine;
      case DrinkType.alcohol:
        return alcoholPercentage;
      case DrinkType.water:
      default:
        return null;
    }
  }

  DrinkEntry copyWith({
    String? name,
    int? volume,
    int? caffeine,
    double? alcoholPercentage,
    String? time,
    DateTime? date,
    DrinkType? type,
    String? comments,
    String? imageId,
  }) {
    return DrinkEntry(
      id: this.id,
      name: name ?? this.name,
      volume: volume ?? this.volume,
      caffeine: caffeine ?? this.caffeine,
      alcoholPercentage: alcoholPercentage ?? this.alcoholPercentage,
      time: time ?? this.time,
      date: date ?? this.date,
      type: type ?? this.type,
      comments: comments ?? this.comments,
      imageId: imageId ?? this.imageId,
    );
  }
}
