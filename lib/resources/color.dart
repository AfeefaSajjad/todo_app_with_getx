import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3A4F7A);

  static const Color secondaryColor = Color(0xFF5A7F9A);

  static const Color backgroundColor = Color(0xFFF5F7FA);

  static const Color surfaceColor = Colors.white;
  static const Color labelColor = Colors.black26;

  static const Color textColor = Color(0xFF333333);
  static const Color primaryTextColor = Color(0xFF212121);

  static const Color subtitleTextColor = Color(0xFF666666);
  static const Color incompleteTaskColor = Color(0xFFE0E0E0);

  static const Color appBarColor = Color(0xFF3A4F7A);
  static const Color successLight = Color(0xFFCCE6CC);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color successDark = Color(0xFF088E3C);

  static const Color errorDark = Color(0xFFD32F2F);

  static const Color borderColor = Color(0xFF3A4F7A);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);

  static const Color fabColor = Color(0xFF3A4F7A);

  static const Color dividerColor = Color(0xFFDDDDDD);

  static const Color fabIconColor = Colors.white;

  static const Color secondaryTextColor = Colors.black45;
  static const Color editIconColor = Colors.blue;
  static const Color deleteIconColor = Colors.red;
  static const Color checkboxActiveColor = Colors.green;
  static const Color errorColor = Color(0xFFB00020);
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color dangerColor = Color(0xFFB00020);
}

ThemeData buildAppTheme() {
  return ThemeData(
    primaryColor: AppTheme.primaryColor,
    scaffoldBackgroundColor: AppTheme.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppTheme.appBarColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppTheme.textColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppTheme.subtitleTextColor,
        fontSize: 14,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppTheme.fabColor,
    ),
    cardColor: AppTheme.surfaceColor,
    dividerColor: AppTheme.dividerColor,
    iconTheme: const IconThemeData(
      color: AppTheme.primaryColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppTheme.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
