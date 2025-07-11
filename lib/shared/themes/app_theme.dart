import 'package:flutter/material.dart';

class AppTheme {
  // Figma-inspired color palette
  static const Color kPrimary = Color(0xFFFFD700); // Yellow (paper note color)
  static const Color kSecondary = Color(0xFF232946); // Deep blue
  static const Color kBackgroundLight = Color(0xFFF4F4F6); // Light gray
  static const Color kSurfaceLight = Color(0xFFFFFFFF); // White
  static const Color kError = Color(0xFFFF5C5C); // Red
  static const Color kTextLight = Color(0xFF232946); // Deep blue
  static const Color kHintLight = Color(0xFF9A9A9A); // Gray
  static const Color kBorderLight = Color(0xFFE0E0E0); // Light border

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: kPrimary,
        onPrimary: Colors.black,
        secondary: kSecondary,
        onSecondary: Colors.white,
        error: kError,
        onError: Colors.white,
        background: kBackgroundLight,
        onBackground: kTextLight,
        surface: kSurfaceLight,
        onSurface: kTextLight,
      ),
      scaffoldBackgroundColor: kBackgroundLight,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: kBackgroundLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: kTextLight,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        iconTheme: IconThemeData(color: kTextLight),
      ),
      cardTheme: CardThemeData(
        color: kSurfaceLight,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kBorderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kBorderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kPrimary, width: 2),
        ),
        filled: true,
        fillColor: kSurfaceLight,
        hintStyle: const TextStyle(color: kHintLight),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          elevation: 1,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kPrimary,
        foregroundColor: Colors.black,
        elevation: 2,
        shape: StadiumBorder(),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: kTextLight,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleMedium: TextStyle(
          color: kTextLight,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(color: kTextLight, fontSize: 16),
        bodyMedium: TextStyle(color: kTextLight, fontSize: 15),
        labelSmall: TextStyle(color: kHintLight, fontSize: 13),
      ),
      iconTheme: const IconThemeData(color: kTextLight, size: 24),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey,
        labelStyle: const TextStyle(color: kTextLight, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerColor: kBorderLight,
      splashColor: kPrimary.withOpacity(0.08),
      highlightColor: kPrimary.withOpacity(0.04),
    );
  }

  static ThemeData get darkTheme {
    const Color kBackgroundDark = Color(0xFF18191A);
    const Color kSurfaceDark = Color(0xFF232323);
    const Color kTextDark = Colors.white;
    const Color kHintDark = Color(0xFF8E8E93);
    const Color kBorderDark = Color(0xFF3A3A3C);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: kPrimary,
        onPrimary: Colors.black,
        secondary: kSecondary,
        onSecondary: Colors.white,
        error: kError,
        onError: Colors.white,
        background: kBackgroundDark,
        onBackground: kTextDark,
        surface: kSurfaceDark,
        onSurface: kTextDark,
      ),
      scaffoldBackgroundColor: kBackgroundDark,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: kBackgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: kTextDark,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        iconTheme: IconThemeData(color: kTextDark),
      ),
      cardTheme: CardThemeData(
        color: kSurfaceDark,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kBorderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kBorderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kPrimary, width: 2),
        ),
        filled: true,
        fillColor: kSurfaceDark,
        hintStyle: const TextStyle(color: kHintDark),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          elevation: 1,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kPrimary,
        foregroundColor: Colors.black,
        elevation: 2,
        shape: StadiumBorder(),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: kTextDark,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleMedium: TextStyle(
          color: kTextDark,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(color: kTextDark, fontSize: 16),
        bodyMedium: TextStyle(color: kTextDark, fontSize: 15),
        labelSmall: TextStyle(color: kHintDark, fontSize: 13),
      ),
      iconTheme: const IconThemeData(color: kTextDark, size: 24),
      chipTheme: ChipThemeData(
        backgroundColor: kSurfaceDark,
        labelStyle: const TextStyle(color: kTextDark, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerColor: kBorderDark,
      splashColor: kPrimary.withOpacity(0.08),
      highlightColor: kPrimary.withOpacity(0.04),
    );
  }
}
