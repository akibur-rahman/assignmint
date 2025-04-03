import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryGreen = Color(0xff15803d);
  static const Color backgroundGreen = Color(0xfff0fdf4);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Ensure this is applied
    primaryColor: primaryGreen,
    focusColor: primaryGreen,
    highlightColor: primaryGreen,

    colorScheme: ColorScheme.light(
      primary: primaryGreen,
      secondary: Color(0xff16a34a),
      onPrimary: Colors.white,
      surface: backgroundGreen,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryGreen,
      selectionColor: primaryGreen.withAlpha(100),
      selectionHandleColor: primaryGreen,
    ),

    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryGreen),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryGreen),
      ),
      focusColor: primaryGreen,
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: primaryGreen),
    ),
  );

  static final TextStyle HeadingTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: primaryGreen,
    fontSize: 24,
  );
}
