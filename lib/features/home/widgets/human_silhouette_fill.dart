import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays a human body silhouette.
class HumanSilhouetteFill extends StatelessWidget {
  /// The percentage of the silhouette filled with water (0-100)
  final double waterPercentage;

  /// The percentage of the silhouette filled with coffee (0-100)
  final double coffeePercentage;

  /// The percentage of the silhouette filled with alcohol (0-100)
  final double alcoholPercentage;

  const HumanSilhouetteFill({
    Key? key,
    required this.waterPercentage,
    required this.coffeePercentage,
    required this.alcoholPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simply display the SVG without any fills
    return SizedBox(
      width: 100,
      height: 240,
      child: SvgPicture.asset(
        'assets/images/body_silhouette.svg',
        width: 100,
        height: 240,
        fit: BoxFit.contain,
      ),
    );
  }
}
