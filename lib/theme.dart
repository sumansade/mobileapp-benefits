import 'package:flutter/material.dart';

/// Visa-style brand colors.
class AppColors {
  AppColors._();

  /// Visa blue — primary brand color.
  static const Color visaBlue = Color(0xFF1A1F71);

  /// Lighter Visa blue for gradients / surfaces.
  static const Color visaBlueMid = Color(0xFF2A3494);

  /// Lightest Visa blue tint.
  static const Color visaBlueLight = Color(0xFF3D4DB7);

  /// Gold accent — sparingly for premium highlights.
  static const Color gold = Color(0xFFF7B600);

  /// Dark gold for on-gold text.
  static const Color goldDark = Color(0xFFC49200);

  /// Card gradient start.
  static const Color cardGradientStart = Color(0xFF1A1F71);

  /// Card gradient end.
  static const Color cardGradientEnd = Color(0xFF3D4DB7);
}

/// Build the light Visa-style Material 3 theme.
ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.visaBlue,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.visaBlue,
    onPrimary: Colors.white,
    secondary: AppColors.gold,
    onSecondary: Colors.black,
    tertiary: AppColors.visaBlueMid,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.visaBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.3,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.visaBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.visaBlue,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: AppColors.visaBlue, width: 1.5),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.visaBlue,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline.withAlpha(80)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.visaBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withAlpha(80),
      thickness: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
      headlineSmall: TextStyle(fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

/// Build the dark Visa-style Material 3 theme.
ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.visaBlue,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.visaBlueLight,
    secondary: AppColors.gold,
    onSecondary: Colors.black,
    tertiary: AppColors.visaBlueMid,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        letterSpacing: 0.3,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline.withAlpha(80)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withAlpha(80),
      thickness: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
      headlineSmall: TextStyle(fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
