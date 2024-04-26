import 'package:flash/Themes/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        background: AppColors.primary,
        secondary: AppColors.secondary));
