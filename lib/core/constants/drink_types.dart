enum DrinkType { water, coffee, alcohol }

class DrinkTypes {
  static const Map<DrinkType, String> names = {
    DrinkType.water: 'Water',
    DrinkType.coffee: 'Coffee',
    DrinkType.alcohol: 'Alcohol',
  };

  static const Map<DrinkType, String> colors = {
    DrinkType.water: '#4FC3F7',
    DrinkType.coffee: '#FF9800',
    DrinkType.alcohol: '#E53935',
  };

  static const Map<DrinkType, String> icons = {
    DrinkType.water: 'assets/images/drop.svg',
    DrinkType.coffee: 'assets/images/coffee.svg',
    DrinkType.alcohol: 'assets/images/alcohol-glasses.svg',
  };

  static String getName(DrinkType type) => names[type] ?? 'Unknown';
  static String getColor(DrinkType type) => colors[type] ?? '#CCCCCC';
  static String getIcon(DrinkType type) =>
      icons[type] ?? 'assets/images/drop.svg';
}
