import 'package:flutter/material.dart';

class AppTheme {
  static const Color appBg = Color(0xFF111111);
  static const Color primary = Color(0xFFFFC700);
  static const Color secondary = Color(0xFF006b61);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color controlsBg = Color(0xFF2B2B2B);
  static const Color outline = Color(0xFF666666);
  static const Color outlineVariant = Color(0xFF4A4A4A);

  static const double spacing = 4;
  static const double spacing2 = 8;
  static const double spacing3 = 12;
  static const double spacing4 = 16;
  static const double spacing6 = 24;

  static const double radiusSmall = 12;
  static const double radiusMedium = 16;

  static const double cardImageAspectRatio = 4 / 3;

  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  static const double lineHeightTight = 1.15;
  static const double lineHeightRelaxed = 1.5;

  static ThemeData dark() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primary,
          onPrimary: appBg,
          secondary: secondary,
          onSecondary: appBg,
          surface: controlsBg,
          onSurface: textPrimary,
          primaryContainer: controlsBg,
          onPrimaryContainer: textPrimary,
          secondaryContainer: controlsBg,
          onSecondaryContainer: textPrimary,
          surfaceTint: Colors.transparent,
          outline: outline,
          outlineVariant: outlineVariant,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: appBg,
      canvasColor: appBg,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: controlsBg,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: controlsBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.65)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: secondary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: controlsBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: controlsBg,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
    );
  }
}
