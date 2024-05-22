import 'package:firstbus/utils/colors_utils.dart';
import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  const int primaryColorValue = 0xFFFF6D38;
  MaterialColor primarySwatch = const MaterialColor(primaryColorValue, {
    50: Color(0xFFFF6D38),
    100: Color(0xFFFF6D38),
    200: Color(0xFFFF6D38),
    300: Color(0xFFFF6D38),
    400: Color(0xFFFF6D38),
    500: Color(primaryColorValue),
    600: Color(0xFFFF6D38),
    700: Color(0xFFFF6D38),
    800: Color(0xFFFF6D38),
    900: Color(0xFFFF6D38),
  });

  return ThemeData(
    useMaterial3: false,
    primarySwatch: primarySwatch,
    unselectedWidgetColor: AppColors.radioUnselectedcolor,
    primaryColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.secondaryColor,
  );
}
