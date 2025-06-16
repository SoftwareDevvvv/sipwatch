import '../../core/constants/drink_types.dart';

class DrinkEntry {
  final int? id;
  final int? userId;
  final DrinkType drinkType;
  final String name;
  final int volumeML;
  final int caffeineMG;
  final double alcoholPercentage;
  final String? photoPath;
  final DateTime consumptionTime;
  final DateTime? createdAt;

  DrinkEntry({
    this.id,
    this.userId,
    required this.drinkType,
    required this.name,
    required this.volumeML,
    this.caffeineMG = 0,
    this.alcoholPercentage = 0.0,
    this.photoPath,
    required this.consumptionTime,
    this.createdAt,
  });

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'drink_type': drinkType.name,
      'name': name,
      'volume_ml': volumeML,
      'caffeine_mg': caffeineMG,
      'alcohol_percentage': alcoholPercentage,
      'photo_path': photoPath,
      'consumption_time': consumptionTime.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  // Create from database map
  factory DrinkEntry.fromMap(Map<String, dynamic> map) {
    return DrinkEntry(
      id: map['id'],
      userId: map['user_id'],
      drinkType: DrinkType.values.firstWhere(
        (type) => type.name == map['drink_type'],
        orElse: () => DrinkType.water,
      ),
      name: map['name'] ?? '',
      volumeML: map['volume_ml'] ?? 0,
      caffeineMG: map['caffeine_mg'] ?? 0,
      alcoholPercentage: map['alcohol_percentage']?.toDouble() ?? 0.0,
      photoPath: map['photo_path'],
      consumptionTime: DateTime.parse(map['consumption_time']),
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  // Copy with modifications
  DrinkEntry copyWith({
    int? id,
    int? userId,
    DrinkType? drinkType,
    String? name,
    int? volumeML,
    int? caffeineMG,
    double? alcoholPercentage,
    String? photoPath,
    DateTime? consumptionTime,
    DateTime? createdAt,
  }) {
    return DrinkEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      drinkType: drinkType ?? this.drinkType,
      name: name ?? this.name,
      volumeML: volumeML ?? this.volumeML,
      caffeineMG: caffeineMG ?? this.caffeineMG,
      alcoholPercentage: alcoholPercentage ?? this.alcoholPercentage,
      photoPath: photoPath ?? this.photoPath,
      consumptionTime: consumptionTime ?? this.consumptionTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'DrinkEntry(id: $id, name: $name, type: ${drinkType.name}, volume: ${volumeML}ml)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrinkEntry &&
        other.id == id &&
        other.name == name &&
        other.drinkType == drinkType &&
        other.volumeML == volumeML;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ drinkType.hashCode ^ volumeML.hashCode;
  }
}
