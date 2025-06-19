import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class BodySilhouettePainter extends CustomPainter {
  final double waterPercentage;
  final double coffeePercentage;
  final double alcoholPercentage;

  BodySilhouettePainter({
    required this.waterPercentage,
    required this.coffeePercentage,
    required this.alcoholPercentage,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // Calculate gradient stops based on percentages
    final total = waterPercentage + coffeePercentage + alcoholPercentage;

    // Define colors
    const waterColor = AppColors.water;
    const coffeeColor = AppColors.coffee; // Material brown
    const alcoholColor = AppColors.alcohol; // Material red
    const defaultColor =
        Colors.white; // Default color when all percentages are 0

    // Create gradient with hard stops
    Shader gradient;

    if (total == 0) {
      // If all percentages are 0, fill with white
      gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [defaultColor, defaultColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      // Calculate stops for each liquid type
      final waterStop = waterPercentage / total;
      final coffeeStop = (waterPercentage + coffeePercentage) / total;

      gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.0, waterStop, waterStop, coffeeStop, coffeeStop, 1.0],
        colors: [
          waterColor,
          waterColor,
          coffeeColor,
          coffeeColor,
          alcoholColor,
          alcoholColor,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    // Define silhouette path (same as your original path)
    Path silhouettePath = Path();
    silhouettePath.moveTo(size.width * 0.9906724, size.height * 0.5302946);
    silhouettePath.cubicTo(
        size.width * 0.9841673,
        size.height * 0.5268672,
        size.width * 0.9710378,
        size.height * 0.5137344,
        size.width * 0.9651714,
        size.height * 0.5093859);
    silhouettePath.cubicTo(
        size.width * 0.9593112,
        size.height * 0.5050373,
        size.width * 0.9374286,
        size.height * 0.4903610,
        size.width * 0.9206245,
        size.height * 0.4835021);
    silhouettePath.cubicTo(
        size.width * 0.9164745,
        size.height * 0.4818091,
        size.width * 0.9123051,
        size.height * 0.4806017,
        size.width * 0.9083765,
        size.height * 0.4797427);
    silhouettePath.cubicTo(
        size.width * 0.8962214,
        size.height * 0.4678050,
        size.width * 0.8814531,
        size.height * 0.4197842,
        size.width * 0.8731439,
        size.height * 0.3832639);
    silhouettePath.cubicTo(
        size.width * 0.8643500,
        size.height * 0.3446245,
        size.width * 0.8356276,
        size.height * 0.3293183,
        size.width * 0.8356276,
        size.height * 0.3293183);
    silhouettePath.cubicTo(
        size.width * 0.8397306,
        size.height * 0.2977046,
        size.width * 0.8151112,
        size.height * 0.2648349,
        size.width * 0.8158949,
        size.height * 0.2570573);
    silhouettePath.cubicTo(
        size.width * 0.8166786,
        size.height * 0.2492793,
        size.width * 0.8158949,
        size.height * 0.2250241,
        size.width * 0.8158949,
        size.height * 0.2250241);
    silhouettePath.cubicTo(
        size.width * 0.8115959,
        size.height * 0.1852129,
        size.width * 0.7623582,
        size.height * 0.1775191,
        size.width * 0.7088204,
        size.height * 0.1701585);
    silhouettePath.cubicTo(
        size.width * 0.6552827,
        size.height * 0.1627975,
        size.width * 0.5900235,
        size.height * 0.1487469,
        size.width * 0.5802500,
        size.height * 0.1450664);
    silhouettePath.cubicTo(
        size.width * 0.5704816,
        size.height * 0.1413863,
        size.width * 0.5704816,
        size.height * 0.1353647,
        size.width * 0.5700898,
        size.height * 0.1254954);
    silhouettePath.cubicTo(
        size.width * 0.5697143,
        size.height * 0.1159456,
        size.width * 0.5792041,
        size.height * 0.1057676,
        size.width * 0.5869000,
        size.height * 0.09420788);
    silhouettePath.cubicTo(
        size.width * 0.6076173,
        size.height * 0.09399834,
        size.width * 0.6198337,
        size.height * 0.06736846,
        size.width * 0.6095602,
        size.height * 0.06494357);
    silhouettePath.cubicTo(
        size.width * 0.6058541,
        size.height * 0.06406763,
        size.width * 0.6030704,
        size.height * 0.06400166,
        size.width * 0.6009980,
        size.height * 0.06430373);
    silhouettePath.cubicTo(
        size.width * 0.6042510,
        size.height * 0.05075851,
        size.width * 0.6028847,
        size.height * 0.03550531,
        size.width * 0.5876786,
        size.height * 0.02362797);
    silhouettePath.cubicTo(
        size.width * 0.5587602,
        size.height * 0.001047158,
        size.width * 0.5024857,
        size.height * 0.001883402,
        size.width * 0.5024857,
        size.height * 0.001883402);
    silhouettePath.lineTo(size.width * 0.4975469, size.height * 0.001883402);
    silhouettePath.cubicTo(
        size.width * 0.4975469,
        size.height * 0.001883402,
        size.width * 0.4412724,
        size.height * 0.001047158,
        size.width * 0.4123541,
        size.height * 0.02362797);
    silhouettePath.cubicTo(
        size.width * 0.3971429,
        size.height * 0.03550531,
        size.width * 0.3957816,
        size.height * 0.05075643,
        size.width * 0.3990347,
        size.height * 0.06430373);
    silhouettePath.cubicTo(
        size.width * 0.3969622,
        size.height * 0.06400166,
        size.width * 0.3941786,
        size.height * 0.06407012,
        size.width * 0.3904724,
        size.height * 0.06494357);
    silhouettePath.cubicTo(
        size.width * 0.3801990,
        size.height * 0.06737095,
        size.width * 0.3924112,
        size.height * 0.09399834,
        size.width * 0.4131327,
        size.height * 0.09420788);
    silhouettePath.cubicTo(
        size.width * 0.4208286,
        size.height * 0.1057676,
        size.width * 0.4303245,
        size.height * 0.1159456,
        size.width * 0.4299429,
        size.height * 0.1254954);
    silhouettePath.cubicTo(
        size.width * 0.4295510,
        size.height * 0.1353647,
        size.width * 0.4295510,
        size.height * 0.1413863,
        size.width * 0.4197827,
        size.height * 0.1450664);
    silhouettePath.cubicTo(
        size.width * 0.4100143,
        size.height * 0.1487469,
        size.width * 0.3447500,
        size.height * 0.1627975,
        size.width * 0.2912122,
        size.height * 0.1701585);
    silhouettePath.cubicTo(
        size.width * 0.2376755,
        size.height * 0.1775191,
        size.width * 0.1884367,
        size.height * 0.1852129,
        size.width * 0.1841378,
        size.height * 0.2250241);
    silhouettePath.cubicTo(
        size.width * 0.1841378,
        size.height * 0.2250241,
        size.width * 0.1833541,
        size.height * 0.2492793,
        size.width * 0.1841378,
        size.height * 0.2570573);
    silhouettePath.cubicTo(
        size.width * 0.1849214,
        size.height * 0.2648349,
        size.width * 0.1603020,
        size.height * 0.2977046,
        size.width * 0.1644051,
        size.height * 0.3293183);
    silhouettePath.cubicTo(
        size.width * 0.1644051,
        size.height * 0.3293183,
        size.width * 0.1356827,
        size.height * 0.3446245,
        size.width * 0.1268888,
        size.height * 0.3832639);
    silhouettePath.cubicTo(
        size.width * 0.1185796,
        size.height * 0.4197842,
        size.width * 0.1038112,
        size.height * 0.4678050,
        size.width * 0.09165612,
        size.height * 0.4797427);
    silhouettePath.cubicTo(
        size.width * 0.08772306,
        size.height * 0.4806017,
        size.width * 0.08355286,
        size.height * 0.4818091,
        size.width * 0.07940837,
        size.height * 0.4835021);
    silhouettePath.cubicTo(
        size.width * 0.06260388,
        size.height * 0.4903568,
        size.width * 0.04072194,
        size.height * 0.5050373,
        size.width * 0.03486092,
        size.height * 0.5093859);
    silhouettePath.cubicTo(
        size.width * 0.02900000,
        size.height * 0.5137344,
        size.width * 0.01586561,
        size.height * 0.5268672,
        size.width * 0.009360316,
        size.height * 0.5302946);
    silhouettePath.cubicTo(
        size.width * 0.001741571,
        size.height * 0.5343071,
        size.width * 0.002787990,
        size.height * 0.5402324,
        size.width * 0.01639653,
        size.height * 0.5374481);
    silhouettePath.cubicTo(
        size.width * 0.02987622,
        size.height * 0.5346846,
        size.width * 0.04345908,
        size.height * 0.5279544,
        size.width * 0.04892827,
        size.height * 0.5239378);
    silhouettePath.cubicTo(
        size.width * 0.05439745,
        size.height * 0.5199212,
        size.width * 0.05830480,
        size.height * 0.5189212,
        size.width * 0.05830480,
        size.height * 0.5189212);
    silhouettePath.cubicTo(
        size.width * 0.05830480,
        size.height * 0.5189212,
        size.width * 0.05103143,
        size.height * 0.5452241,
        size.width * 0.04901071,
        size.height * 0.5532158);
    silhouettePath.cubicTo(
        size.width * 0.04676327,
        size.height * 0.5620830,
        size.width * 0.03896408,
        size.height * 0.5742075,
        size.width * 0.04971184,
        size.height * 0.5754606);
    silhouettePath.cubicTo(
        size.width * 0.06152133,
        size.height * 0.5768382,
        size.width * 0.06456265,
        size.height * 0.5701079,
        size.width * 0.06651633,
        size.height * 0.5649212);
    silhouettePath.cubicTo(
        size.width * 0.06847000,
        size.height * 0.5597344,
        size.width * 0.08059918,
        size.height * 0.5348091,
        size.width * 0.08444980,
        size.height * 0.5333071);
    silhouettePath.cubicTo(
        size.width * 0.08925398,
        size.height * 0.5314357,
        size.width * 0.08714051,
        size.height * 0.5343402,
        size.width * 0.08605286,
        size.height * 0.5403320);
    silhouettePath.cubicTo(
        size.width * 0.08568694,
        size.height * 0.5423610,
        size.width * 0.08409918,
        size.height * 0.5525436,
        size.width * 0.08175378,
        size.height * 0.5590664);
    silhouettePath.cubicTo(
        size.width * 0.07940837,
        size.height * 0.5655934,
        size.width * 0.07159378,
        size.height * 0.5801452,
        size.width * 0.08800653,
        size.height * 0.5793071);
    silhouettePath.cubicTo(
        size.width * 0.1044194,
        size.height * 0.5784689,
        size.width * 0.1083265,
        size.height * 0.5391618,
        size.width * 0.1110643,
        size.height * 0.5363195);
    silhouettePath.cubicTo(
        size.width * 0.1138010,
        size.height * 0.5334730,
        size.width * 0.1161459,
        size.height * 0.5346473,
        size.width * 0.1145796,
        size.height * 0.5416722);
    silhouettePath.cubicTo(
        size.width * 0.1140847,
        size.height * 0.5438921,
        size.width * 0.1055898,
        size.height * 0.5702739,
        size.width * 0.1087184,
        size.height * 0.5756266);
    silhouettePath.cubicTo(
        size.width * 0.1118418,
        size.height * 0.5809793,
        size.width * 0.1239612,
        size.height * 0.5801452,
        size.width * 0.1278684,
        size.height * 0.5732863);
    silhouettePath.cubicTo(
        size.width * 0.1317755,
        size.height * 0.5664274,
        size.width * 0.1356827,
        size.height * 0.5386598,
        size.width * 0.1384204,
        size.height * 0.5366556);
    silhouettePath.cubicTo(
        size.width * 0.1411571,
        size.height * 0.5346473,
        size.width * 0.1419357,
        size.height * 0.5383278,
        size.width * 0.1411520,
        size.height * 0.5433444);
    silhouettePath.cubicTo(
        size.width * 0.1405796,
        size.height * 0.5470166,
        size.width * 0.1356827,
        size.height * 0.5670996,
        size.width * 0.1450592,
        size.height * 0.5679336);
    silhouettePath.cubicTo(
        size.width * 0.1544357,
        size.height * 0.5687718,
        size.width * 0.1582500,
        size.height * 0.5663029,
        size.width * 0.1608490,
        size.height * 0.5516266);
    silhouettePath.cubicTo(
        size.width * 0.1631265,
        size.height * 0.5387759,
        size.width * 0.1634255,
        size.height * 0.5316349,
        size.width * 0.1649878,
        size.height * 0.5234398);
    silhouettePath.cubicTo(
        size.width * 0.1665500,
        size.height * 0.5152448,
        size.width * 0.1685031,
        size.height * 0.4911577,
        size.width * 0.1591265,
        size.height * 0.4837967);
    silhouettePath.cubicTo(
        size.width * 0.1591265,
        size.height * 0.4837967,
        size.width * 0.1708490,
        size.height * 0.4590415,
        size.width * 0.1950816,
        size.height * 0.4376307);
    silhouettePath.cubicTo(
        size.width * 0.2193082,
        size.height * 0.4162199,
        size.width * 0.2552633,
        size.height * 0.3787519,
        size.width * 0.2537010,
        size.height * 0.3603523);
    silhouettePath.cubicTo(
        size.width * 0.2524020,
        size.height * 0.3450726,
        size.width * 0.2823612,
        size.height * 0.2919631,
        size.width * 0.2934551,
        size.height * 0.2740050);
    silhouettePath.cubicTo(
        size.width * 0.2945061,
        size.height * 0.2784817,
        size.width * 0.2960378,
        size.height * 0.2832232,
        size.width * 0.2982490,
        size.height * 0.2880909);
    silhouettePath.cubicTo(
        size.width * 0.3091918,
        size.height * 0.3121788,
        size.width * 0.3256051,
        size.height * 0.3412838,
        size.width * 0.3232592,
        size.height * 0.3593481);
    silhouettePath.cubicTo(
        size.width * 0.3209143,
        size.height * 0.3774145,
        size.width * 0.3162235,
        size.height * 0.4048473,
        size.width * 0.3115378,
        size.height * 0.4155519);
    silhouettePath.cubicTo(
        size.width * 0.3068469,
        size.height * 0.4262573,
        size.width * 0.2787122,
        size.height * 0.4677386,
        size.width * 0.2794959,
        size.height * 0.5189253);
    silhouettePath.cubicTo(
        size.width * 0.2802796,
        size.height * 0.5701120,
        size.width * 0.2966918,
        size.height * 0.6304938,
        size.width * 0.3045061,
        size.height * 0.6432075);
    silhouettePath.cubicTo(
        size.width * 0.3123214,
        size.height * 0.6559212,
        size.width * 0.3145735,
        size.height * 0.6685187,
        size.width * 0.3122286,
        size.height * 0.6772199);
    silhouettePath.cubicTo(
        size.width * 0.3098827,
        size.height * 0.6859170,
        size.width * 0.3052898,
        size.height * 0.7052656,
        size.width * 0.3099755,
        size.height * 0.7183154);
    silhouettePath.cubicTo(
        size.width * 0.3099755,
        size.height * 0.7183154,
        size.width * 0.2912173,
        size.height * 0.7524357,
        size.width * 0.3060684,
        size.height * 0.7989378);
    silhouettePath.cubicTo(
        size.width * 0.3209194,
        size.height * 0.8454398,
        size.width * 0.3474918,
        size.height * 0.8966266,
        size.width * 0.3474918,
        size.height * 0.9019793);
    silhouettePath.cubicTo(
        size.width * 0.3474918,
        size.height * 0.9024564,
        size.width * 0.3474918,
        size.height * 0.9031826,
        size.width * 0.3474918,
        size.height * 0.9041037);
    silhouettePath.cubicTo(
        size.width * 0.3462133,
        size.height * 0.9066017,
        size.width * 0.3447959,
        size.height * 0.9090871,
        size.width * 0.3435173,
        size.height * 0.9115809);
    silhouettePath.cubicTo(
        size.width * 0.3419714,
        size.height * 0.9145975,
        size.width * 0.3409306,
        size.height * 0.9176183,
        size.width * 0.3407347,
        size.height * 0.9207095);
    silhouettePath.cubicTo(
        size.width * 0.3405439,
        size.height * 0.9237676,
        size.width * 0.3409459,
        size.height * 0.9268174,
        size.width * 0.3410694,
        size.height * 0.9298755);
    silhouettePath.cubicTo(
        size.width * 0.3411571,
        size.height * 0.9320207,
        size.width * 0.3410173,
        size.height * 0.9341577,
        size.width * 0.3405337,
        size.height * 0.9362863);
    silhouettePath.cubicTo(
        size.width * 0.3369408,
        size.height * 0.9394066,
        size.width * 0.3326102,
        size.height * 0.9424108,
        size.width * 0.3281724,
        size.height * 0.9452780);
    silhouettePath.cubicTo(
        size.width * 0.3221459,
        size.height * 0.9491743,
        size.width * 0.3153316,
        size.height * 0.9528340,
        size.width * 0.3084041,
        size.height * 0.9564398);
    silhouettePath.cubicTo(
        size.width * 0.3014082,
        size.height * 0.9600747,
        size.width * 0.2942694,
        size.height * 0.9636680,
        size.width * 0.2875990,
        size.height * 0.9674191);
    silhouettePath.cubicTo(
        size.width * 0.2842847,
        size.height * 0.9692822,
        size.width * 0.2810837,
        size.height * 0.9711867,
        size.width * 0.2780837,
        size.height * 0.9731494);
    silhouettePath.cubicTo(
        size.width * 0.2749541,
        size.height * 0.9751909,
        size.width * 0.2714184,
        size.height * 0.9773402,
        size.width * 0.2703051,
        size.height * 0.9797842);
    silhouettePath.cubicTo(
        size.width * 0.2692735,
        size.height * 0.9820332,
        size.width * 0.2707684,
        size.height * 0.9843071,
        size.width * 0.2757796,
        size.height * 0.9853776);
    silhouettePath.cubicTo(
        size.width * 0.2767796,
        size.height * 0.9855934,
        size.width * 0.2778408,
        size.height * 0.9857261,
        size.width * 0.2789031,
        size.height * 0.9857884);
    silhouettePath.cubicTo(
        size.width * 0.2787684,
        size.height * 0.9864772,
        size.width * 0.2788663,
        size.height * 0.9871826,
        size.width * 0.2793306,
        size.height * 0.9879087);
    silhouettePath.cubicTo(
        size.width * 0.2810316,
        size.height * 0.9905726,
        size.width * 0.2873673,
        size.height * 0.9924896,
        size.width * 0.2937439,
        size.height * 0.9925685);
    silhouettePath.cubicTo(
        size.width * 0.2946041,
        size.height * 0.9938382,
        size.width * 0.2967898,
        size.height * 0.9948050,
        size.width * 0.3001765,
        size.height * 0.9952199);
    silhouettePath.cubicTo(
        size.width * 0.3043214,
        size.height * 0.9957220,
        size.width * 0.3088214,
        size.height * 0.9951950,
        size.width * 0.3125224,
        size.height * 0.9942780);
    silhouettePath.cubicTo(
        size.width * 0.3127082,
        size.height * 0.9946805,
        size.width * 0.3130122,
        size.height * 0.9950788,
        size.width * 0.3134704,
        size.height * 0.9954647);
    silhouettePath.cubicTo(
        size.width * 0.3157796,
        size.height * 0.9973942,
        size.width * 0.3209347,
        size.height * 0.9982241,
        size.width * 0.3257806,
        size.height * 0.9981618);
    silhouettePath.cubicTo(
        size.width * 0.3315071,
        size.height * 0.9980871,
        size.width * 0.3363684,
        size.height * 0.9966432,
        size.width * 0.3401827,
        size.height * 0.9949129);
    silhouettePath.cubicTo(
        size.width * 0.3421571,
        size.height * 0.9940166,
        size.width * 0.3439510,
        size.height * 0.9930581,
        size.width * 0.3457398,
        size.height * 0.9921037);
    silhouettePath.cubicTo(
        size.width * 0.3449867,
        size.height * 0.9933942,
        size.width * 0.3449204,
        size.height * 0.9947427,
        size.width * 0.3460388,
        size.height * 0.9959959);
    silhouettePath.cubicTo(
        size.width * 0.3481265,
        size.height * 0.9983361,
        size.width * 0.3540643,
        size.height * 0.9995145,
        size.width * 0.3595235,
        size.height * 0.9998465);
    silhouettePath.cubicTo(
        size.width * 0.3647041,
        size.height * 1.000162,
        size.width * 0.3699408,
        size.height * 0.9997178,
        size.width * 0.3746010,
        size.height * 0.9987220);
    silhouettePath.cubicTo(
        size.width * 0.3763898,
        size.height * 0.9983402,
        size.width * 0.3782194,
        size.height * 0.9978548,
        size.width * 0.3799204,
        size.height * 0.9972780);
    silhouettePath.cubicTo(
        size.width * 0.3831112,
        size.height * 0.9966100,
        size.width * 0.3860184,
        size.height * 0.9956349,
        size.width * 0.3884980,
        size.height * 0.9945768);
    silhouettePath.cubicTo(
        size.width * 0.3940143,
        size.height * 0.9922365,
        size.width * 0.3978184,
        size.height * 0.9893195,
        size.width * 0.4006837,
        size.height * 0.9862531);
    silhouettePath.cubicTo(
        size.width * 0.4070347,
        size.height * 0.9794647,
        size.width * 0.4090765,
        size.height * 0.9720913,
        size.width * 0.4123908,
        size.height * 0.9649668);
    silhouettePath.cubicTo(
        size.width * 0.4130143,
        size.height * 0.9636307,
        size.width * 0.4136643,
        size.height * 0.9622780,
        size.width * 0.4143806,
        size.height * 0.9609295);
    silhouettePath.cubicTo(
        size.width * 0.4147929,
        size.height * 0.9610498,
        size.width * 0.4154418,
        size.height * 0.9610373,
        size.width * 0.4160041,
        size.height * 0.9607925);
    silhouettePath.cubicTo(
        size.width * 0.4231122,
        size.height * 0.9577054,
        size.width * 0.4258551,
        size.height * 0.9527095,
        size.width * 0.4267051,
        size.height * 0.9485311);
    silhouettePath.cubicTo(
        size.width * 0.4277469,
        size.height * 0.9434025,
        size.width * 0.4259214,
        size.height * 0.9382905,
        size.width * 0.4237051,
        size.height * 0.9332656);
    silhouettePath.cubicTo(
        size.width * 0.4213551,
        size.height * 0.9279336,
        size.width * 0.4190296,
        size.height * 0.9226183,
        size.width * 0.4175561,
        size.height * 0.9172241);
    silhouettePath.cubicTo(
        size.width * 0.4160867,
        size.height * 0.9118340,
        size.width * 0.4152776,
        size.height * 0.9064149,
        size.width * 0.4146745,
        size.height * 0.9010000);
    silhouettePath.cubicTo(
        size.width * 0.4143439,
        size.height * 0.8980207,
        size.width * 0.4140449,
        size.height * 0.8950415,
        size.width * 0.4137459,
        size.height * 0.8920622);
    silhouettePath.cubicTo(
        size.width * 0.4137255,
        size.height * 0.8918423,
        size.width * 0.4136949,
        size.height * 0.8916266,
        size.width * 0.4136745,
        size.height * 0.8914066);
    silhouettePath.cubicTo(
        size.width * 0.4150969,
        size.height * 0.8831369,
        size.width * 0.4167408,
        size.height * 0.8750788,
        size.width * 0.4186122,
        size.height * 0.8681909);
    silhouettePath.cubicTo(
        size.width * 0.4264265,
        size.height * 0.8394191,
        size.width * 0.4537837,
        size.height * 0.7915809,
        size.width * 0.4467469,
        size.height * 0.7668257);
    silhouettePath.cubicTo(
        size.width * 0.4397112,
        size.height * 0.7420664,
        size.width * 0.4482837,
        size.height * 0.6788382,
        size.width * 0.4557367,
        size.height * 0.6607718);
    silhouettePath.cubicTo(
        size.width * 0.4631908,
        size.height * 0.6427054,
        size.width * 0.4991143,
        size.height * 0.5410083,
        size.width * 0.4913000,
        size.height * 0.5119004);
    silhouettePath.lineTo(size.width * 0.5000214, size.height * 0.5115643);
    silhouettePath.lineTo(size.width * 0.5087439, size.height * 0.5119004);
    silhouettePath.cubicTo(
        size.width * 0.5009286,
        size.height * 0.5410083,
        size.width * 0.5368520,
        size.height * 0.6427095,
        size.width * 0.5443061,
        size.height * 0.6607718);
    silhouettePath.cubicTo(
        size.width * 0.5517602,
        size.height * 0.6788382,
        size.width * 0.5603276,
        size.height * 0.7420664,
        size.width * 0.5532959,
        size.height * 0.7668257);
    silhouettePath.cubicTo(
        size.width * 0.5462602,
        size.height * 0.7915809,
        size.width * 0.5736163,
        size.height * 0.8394191,
        size.width * 0.5814306,
        size.height * 0.8681909);
    silhouettePath.cubicTo(
        size.width * 0.5833020,
        size.height * 0.8750788,
        size.width * 0.5849459,
        size.height * 0.8831369,
        size.width * 0.5863694,
        size.height * 0.8914066);
    silhouettePath.cubicTo(
        size.width * 0.5863429,
        size.height * 0.8916266,
        size.width * 0.5863173,
        size.height * 0.8918423,
        size.width * 0.5862918,
        size.height * 0.8920622);
    silhouettePath.cubicTo(
        size.width * 0.5859929,
        size.height * 0.8950415,
        size.width * 0.5856939,
        size.height * 0.8980207,
        size.width * 0.5853643,
        size.height * 0.9010000);
    silhouettePath.cubicTo(
        size.width * 0.5847663,
        size.height * 0.9064191,
        size.width * 0.5839510,
        size.height * 0.9118340,
        size.width * 0.5824827,
        size.height * 0.9172241);
    silhouettePath.cubicTo(
        size.width * 0.5810082,
        size.height * 0.9226183,
        size.width * 0.5786837,
        size.height * 0.9279336,
        size.width * 0.5763327,
        size.height * 0.9332656);
    silhouettePath.cubicTo(
        size.width * 0.5741163,
        size.height * 0.9382905,
        size.width * 0.5722918,
        size.height * 0.9434025,
        size.width * 0.5733327,
        size.height * 0.9485311);
    silhouettePath.cubicTo(
        size.width * 0.5741837,
        size.height * 0.9527095,
        size.width * 0.5769204,
        size.height * 0.9577054,
        size.width * 0.5840337,
        size.height * 0.9607925);
    silhouettePath.cubicTo(
        size.width * 0.5845908,
        size.height * 0.9610373,
        size.width * 0.5852449,
        size.height * 0.9610498,
        size.width * 0.5856582,
        size.height * 0.9609295);
    silhouettePath.cubicTo(
        size.width * 0.5863745,
        size.height * 0.9622780,
        size.width * 0.5870235,
        size.height * 0.9636307,
        size.width * 0.5876469,
        size.height * 0.9649668);
    silhouettePath.cubicTo(
        size.width * 0.5909622,
        size.height * 0.9720913,
        size.width * 0.5930031,
        size.height * 0.9794647,
        size.width * 0.5993541,
        size.height * 0.9862531);
    silhouettePath.cubicTo(
        size.width * 0.6022255,
        size.height * 0.9893195,
        size.width * 0.6060245,
        size.height * 0.9922365,
        size.width * 0.6115398,
        size.height * 0.9945768);
    silhouettePath.cubicTo(
        size.width * 0.6140245,
        size.height * 0.9956349,
        size.width * 0.6169265,
        size.height * 0.9966100,
        size.width * 0.6201173,
        size.height * 0.9972780);
    silhouettePath.cubicTo(
        size.width * 0.6218184,
        size.height * 0.9978548,
        size.width * 0.6236480,
        size.height * 0.9983402,
        size.width * 0.6254367,
        size.height * 0.9987220);
    silhouettePath.cubicTo(
        size.width * 0.6300969,
        size.height * 0.9997178,
        size.width * 0.6353337,
        size.height * 1.000162,
        size.width * 0.6405143,
        size.height * 0.9998465);
    silhouettePath.cubicTo(
        size.width * 0.6459735,
        size.height * 0.9995145,
        size.width * 0.6519122,
        size.height * 0.9983361,
        size.width * 0.6540000,
        size.height * 0.9959959);
    silhouettePath.cubicTo(
        size.width * 0.6551184,
        size.height * 0.9947427,
        size.width * 0.6550510,
        size.height * 0.9933942,
        size.width * 0.6542990,
        size.height * 0.9921037);
    silhouettePath.cubicTo(
        size.width * 0.6560867,
        size.height * 0.9930622,
        size.width * 0.6578755,
        size.height * 0.9940166,
        size.width * 0.6598551,
        size.height * 0.9949129);
    silhouettePath.cubicTo(
        size.width * 0.6636694,
        size.height * 0.9966432,
        size.width * 0.6685255,
        size.height * 0.9980871,
        size.width * 0.6742571,
        size.height * 0.9981618);
    silhouettePath.cubicTo(
        size.width * 0.6791031,
        size.height * 0.9982241,
        size.width * 0.6842582,
        size.height * 0.9973983,
        size.width * 0.6865673,
        size.height * 0.9954647);
    silhouettePath.cubicTo(
        size.width * 0.6870265,
        size.height * 0.9950788,
        size.width * 0.6873306,
        size.height * 0.9946805,
        size.width * 0.6875153,
        size.height * 0.9942780);
    silhouettePath.cubicTo(
        size.width * 0.6912173,
        size.height * 0.9951950,
        size.width * 0.6957173,
        size.height * 0.9957220,
        size.width * 0.6998612,
        size.height * 0.9952199);
    silhouettePath.cubicTo(
        size.width * 0.7032480,
        size.height * 0.9948050,
        size.width * 0.7054286,
        size.height * 0.9938382,
        size.width * 0.7062949,
        size.height * 0.9925685);
    silhouettePath.cubicTo(
        size.width * 0.7126714,
        size.height * 0.9924896,
        size.width * 0.7190061,
        size.height * 0.9905768,
        size.width * 0.7207071,
        size.height * 0.9879087);
    silhouettePath.cubicTo(
        size.width * 0.7211714,
        size.height * 0.9871826,
        size.width * 0.7212694,
        size.height * 0.9864772,
        size.width * 0.7211347,
        size.height * 0.9857884);
    silhouettePath.cubicTo(
        size.width * 0.7221969,
        size.height * 0.9857261,
        size.width * 0.7232592,
        size.height * 0.9855934,
        size.width * 0.7242643,
        size.height * 0.9853776);
    silhouettePath.cubicTo(
        size.width * 0.7292745,
        size.height * 0.9843071,
        size.width * 0.7307694,
        size.height * 0.9820332,
        size.width * 0.7297388,
        size.height * 0.9797842);
    silhouettePath.cubicTo(
        size.width * 0.7286245,
        size.height * 0.9773402,
        size.width * 0.7250888,
        size.height * 0.9751909,
        size.width * 0.7219602,
        size.height * 0.9731494);
    silhouettePath.cubicTo(
        size.width * 0.7189602,
        size.height * 0.9711867,
        size.width * 0.7157582,
        size.height * 0.9692822,
        size.width * 0.7124439,
        size.height * 0.9674191);
    silhouettePath.cubicTo(
        size.width * 0.7057735,
        size.height * 0.9636680,
        size.width * 0.6986347,
        size.height * 0.9600788,
        size.width * 0.6916398,
        size.height * 0.9564398);
    silhouettePath.cubicTo(
        size.width * 0.6847112,
        size.height * 0.9528340,
        size.width * 0.6778969,
        size.height * 0.9491701,
        size.width * 0.6718714,
        size.height * 0.9452780);
    silhouettePath.cubicTo(
        size.width * 0.6674327,
        size.height * 0.9424066,
        size.width * 0.6631031,
        size.height * 0.9394066,
        size.width * 0.6595102,
        size.height * 0.9362863);
    silhouettePath.cubicTo(
        size.width * 0.6590255,
        size.height * 0.9341577,
        size.width * 0.6588918,
        size.height * 0.9320207,
        size.width * 0.6589735,
        size.height * 0.9298755);
    silhouettePath.cubicTo(
        size.width * 0.6590980,
        size.height * 0.9268174,
        size.width * 0.6595000,
        size.height * 0.9237676,
        size.width * 0.6593092,
        size.height * 0.9207095);
    silhouettePath.cubicTo(
        size.width * 0.6591133,
        size.height * 0.9176183,
        size.width * 0.6580714,
        size.height * 0.9145975,
        size.width * 0.6565255,
        size.height * 0.9115809);
    silhouettePath.cubicTo(
        size.width * 0.6552469,
        size.height * 0.9090830,
        size.width * 0.6538296,
        size.height * 0.9066017,
        size.width * 0.6525510,
        size.height * 0.9041037);
    silhouettePath.cubicTo(
        size.width * 0.6525510,
        size.height * 0.9031826,
        size.width * 0.6525510,
        size.height * 0.9024564,
        size.width * 0.6525510,
        size.height * 0.9019793);
    silhouettePath.cubicTo(
        size.width * 0.6525510,
        size.height * 0.8966266,
        size.width * 0.6791235,
        size.height * 0.8454398,
        size.width * 0.6939745,
        size.height * 0.7989378);
    silhouettePath.cubicTo(
        size.width * 0.7088255,
        size.height * 0.7524398,
        size.width * 0.6900673,
        size.height * 0.7183154,
        size.width * 0.6900673,
        size.height * 0.7183154);
    silhouettePath.cubicTo(
        size.width * 0.6947582,
        size.height * 0.7052656,
        size.width * 0.6901602,
        size.height * 0.6859170,
        size.width * 0.6878143,
        size.height * 0.6772199);
    silhouettePath.cubicTo(
        size.width * 0.6854694,
        size.height * 0.6685187,
        size.width * 0.6877224,
        size.height * 0.6559212,
        size.width * 0.6955367,
        size.height * 0.6432075);
    silhouettePath.cubicTo(
        size.width * 0.7033510,
        size.height * 0.6304938,
        size.width * 0.7197643,
        size.height * 0.5701120,
        size.width * 0.7205480,
        size.height * 0.5189253);
    silhouettePath.cubicTo(
        size.width * 0.7213306,
        size.height * 0.4677386,
        size.width * 0.6931908,
        size.height * 0.4262573,
        size.width * 0.6885051,
        size.height * 0.4155519);
    silhouettePath.cubicTo(
        size.width * 0.6838143,
        size.height * 0.4048452,
        size.width * 0.6791286,
        size.height * 0.3774124,
        size.width * 0.6767837,
        size.height * 0.3593481);
    silhouettePath.cubicTo(
        size.width * 0.6744378,
        size.height * 0.3412838,
        size.width * 0.6908510,
        size.height * 0.3121788,
        size.width * 0.7017949,
        size.height * 0.2880909);
    silhouettePath.cubicTo(
        size.width * 0.7040061,
        size.height * 0.2832257,
        size.width * 0.7055367,
        size.height * 0.2784817,
        size.width * 0.7065888,
        size.height * 0.2740050);
    silhouettePath.cubicTo(
        size.width * 0.7176816,
        size.height * 0.2919631,
        size.width * 0.7476408,
        size.height * 0.3450726,
        size.width * 0.7463418,
        size.height * 0.3603523);
    silhouettePath.cubicTo(
        size.width * 0.7447796,
        size.height * 0.3787519,
        size.width * 0.7807296,
        size.height * 0.4162199,
        size.width * 0.8049571,
        size.height * 0.4376307);
    silhouettePath.cubicTo(
        size.width * 0.8291837,
        size.height * 0.4590415,
        size.width * 0.8409112,
        size.height * 0.4837967,
        size.width * 0.8409112,
        size.height * 0.4837967);
    silhouettePath.cubicTo(
        size.width * 0.8315296,
        size.height * 0.4911577,
        size.width * 0.8334888,
        size.height * 0.5152448,
        size.width * 0.8350500,
        size.height * 0.5234398);
    silhouettePath.cubicTo(
        size.width * 0.8366122,
        size.height * 0.5316390,
        size.width * 0.8369112,
        size.height * 0.5387759,
        size.width * 0.8391898,
        size.height * 0.5516266);
    silhouettePath.cubicTo(
        size.width * 0.8417929,
        size.height * 0.5663029,
        size.width * 0.8456020,
        size.height * 0.5687718,
        size.width * 0.8549786,
        size.height * 0.5679336);
    silhouettePath.cubicTo(
        size.width * 0.8643602,
        size.height * 0.5670996,
        size.width * 0.8594633,
        size.height * 0.5470166,
        size.width * 0.8588857,
        size.height * 0.5433444);
    silhouettePath.cubicTo(
        size.width * 0.8581020,
        size.height * 0.5383278,
        size.width * 0.8588857,
        size.height * 0.5346473,
        size.width * 0.8616173,
        size.height * 0.5366556);
    silhouettePath.cubicTo(
        size.width * 0.8643551,
        size.height * 0.5386639,
        size.width * 0.8682622,
        size.height * 0.5664274,
        size.width * 0.8721694,
        size.height * 0.5732863);
    silhouettePath.cubicTo(
        size.width * 0.8760765,
        size.height * 0.5801452,
        size.width * 0.8881908,
        size.height * 0.5809793,
        size.width * 0.8913194,
        size.height * 0.5756266);
    silhouettePath.cubicTo(
        size.width * 0.8944490,
        size.height * 0.5702739,
        size.width * 0.8859531,
        size.height * 0.5438921,
        size.width * 0.8854582,
        size.height * 0.5416722);
    silhouettePath.cubicTo(
        size.width * 0.8838969,
        size.height * 0.5346473,
        size.width * 0.8862418,
        size.height * 0.5334730,
        size.width * 0.8889745,
        size.height * 0.5363195);
    silhouettePath.cubicTo(
        size.width * 0.8917112,
        size.height * 0.5391618,
        size.width * 0.8956184,
        size.height * 0.5784689,
        size.width * 0.9120316,
        size.height * 0.5793071);
    silhouettePath.cubicTo(
        size.width * 0.9284439,
        size.height * 0.5801452,
        size.width * 0.9206296,
        size.height * 0.5655934,
        size.width * 0.9182847,
        size.height * 0.5590664);
    silhouettePath.cubicTo(
        size.width * 0.9159388,
        size.height * 0.5525436,
        size.width * 0.9143510,
        size.height * 0.5423610,
        size.width * 0.9139847,
        size.height * 0.5403320);
    silhouettePath.cubicTo(
        size.width * 0.9129031,
        size.height * 0.5343361,
        size.width * 0.9107837,
        size.height * 0.5314357,
        size.width * 0.9155878,
        size.height * 0.5333071);
    silhouettePath.cubicTo(
        size.width * 0.9194439,
        size.height * 0.5348091,
        size.width * 0.9315684,
        size.height * 0.5597344,
        size.width * 0.9335214,
        size.height * 0.5649212);
    silhouettePath.cubicTo(
        size.width * 0.9354755,
        size.height * 0.5701079,
        size.width * 0.9385163,
        size.height * 0.5768382,
        size.width * 0.9503265,
        size.height * 0.5754606);
    silhouettePath.cubicTo(
        size.width * 0.9610735,
        size.height * 0.5742033,
        size.width * 0.9532745,
        size.height * 0.5620830,
        size.width * 0.9510276,
        size.height * 0.5532158);
    silhouettePath.cubicTo(
        size.width * 0.9490010,
        size.height * 0.5452241,
        size.width * 0.9417276,
        size.height * 0.5189212,
        size.width * 0.9417276,
        size.height * 0.5189212);
    silhouettePath.cubicTo(
        size.width * 0.9417276,
        size.height * 0.5189212,
        size.width * 0.9456357,
        size.height * 0.5199253,
        size.width * 0.9511092,
        size.height * 0.5239378);
    silhouettePath.cubicTo(
        size.width * 0.9565786,
        size.height * 0.5279502,
        size.width * 0.9701622,
        size.height * 0.5346846,
        size.width * 0.9836418,
        size.height * 0.5374481);
    silhouettePath.cubicTo(
        size.width * 0.9972449,
        size.height * 0.5402324,
        size.width * 0.9982908,
        size.height * 0.5343071,
        size.width * 0.9906724,
        size.height * 0.5302946);
    silhouettePath.close();

    // Draw the silhouette with gradient fill
    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    canvas.drawPath(silhouettePath, paint);
  }

  @override
  bool shouldRepaint(covariant BodySilhouettePainter oldDelegate) {
    return oldDelegate.waterPercentage != waterPercentage ||
        oldDelegate.coffeePercentage != coffeePercentage ||
        oldDelegate.alcoholPercentage != alcoholPercentage;
  }
}
