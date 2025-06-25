import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF29B6F6);
  static const Color primaryLight = Color(0xFFB3E5FC);
  static const Color primaryDark = Color(0xFF0277BD);

  // Background Colors
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFB3E5FC);

  // Text Colors
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF458FC7);
  static const Color textHint = Color(0xFF8E8E93);
  static const Color textButtonColor = Color(0xFF0C4E6A);
  static const Color calendarTextColor = Color(0xFFC74545);
  static const Color iconForegroundColor = Color(0xFF521818);

  // Card Colors
  static const Color cardBackground = Color(0xFFD4F3FF);
  static const Color cardBorder = Color(0xFFC5EFFF);
  static const Color calendarCardColor = Color(0xFFFFD4D4);

  // Input Border:
  static const Color inputBorder = Color(0xFF78B0C9);
  static const Color inputColor = Color(0xFFD4F2FF);

  // Drink Type Colors
  static const Color water = Color(0xFF29B6F6);
  static const Color coffee = Color(0xFFFF9800);
  static const Color alcohol = Color(0xFFF44336);

  // Action Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  static const Color inactive = Color(0xFF49454F);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF3AB5E7);
  static const Color buttonSecondary = Color(0xFFB3E5FC);
  static const Color buttonDanger = Color(0xFFEB6A6A);
  static const Color dangerIcon = Color(0xFF7A3131);

  // Gradient Colors
  static const List<Color> redGradient = [
    Color(0xFFFFCDD2),
    Color(0xFFF44336),
  ];

  static const List<Color> blueGradient = [
    Color(0xFFB3E5FC),
    Color(0xFF29B6F6),
  ];
}

class AppTextStyles {
  // Font Family
  static const String fontFamily = 'Poppins';

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );

  // Special Text Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    color: AppColors.textHint,
    fontFamily: fontFamily,
  );
}

class AppDimensions {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;

  // Icon Sizes
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  // App Bar
  static const double appBarHeight = 80.0;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.textSecondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading2,
        toolbarHeight: AppDimensions.appBarHeight,
        scrolledUnderElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.textButtonColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        titleLarge: AppTextStyles.heading4,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
