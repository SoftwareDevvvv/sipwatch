import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  final double waterPercentage;
  final double coffeePercentage;
  final double alcoholPercentage;

  RPSCustomPainter({
    required this.waterPercentage,
    required this.coffeePercentage,
    required this.alcoholPercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define your silhouette path here (same as your original path)
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9906724, size.height * 0.5302946);
    // ... [REST OF YOUR PATH DATA] ...
    path_0.close();

    // Calculate gradient stops based on percentages
    final total = waterPercentage + coffeePercentage + alcoholPercentage;
    final waterStop = (total > 0) ? waterPercentage / total : 0.0;
    final coffeeStop =
        (total > 0) ? (waterPercentage + coffeePercentage) / total : 0.0;

    // Define colors
    const waterColor = Colors.blue;
    const coffeeColor = Color(0xFF795548); // Brown
    const alcoholColor = Colors.red;

    // Calculate gradient stops based on percentages
    final shaderStops = [
      0.0,
      waterStop,
      waterStop,
      coffeeStop,
      coffeeStop,
      1.0,
    ];

    // Create gradient with calculated stops
    final gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: shaderStops,
      colors: [
        waterColor,
        waterColor,
        coffeeColor,
        coffeeColor,
        alcoholColor,
        alcoholColor,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw the silhouette with gradient fill
    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    canvas.drawPath(path_0, paint);
  }

  @override
  bool shouldRepaint(covariant RPSCustomPainter oldDelegate) {
    return oldDelegate.waterPercentage != waterPercentage ||
        oldDelegate.coffeePercentage != coffeePercentage ||
        oldDelegate.alcoholPercentage != alcoholPercentage;
  }
}
