import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.accent,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surface,
      elevation: AppDimens.toastElevation,
      contentTextStyle: AppTextStyles.toast,
      actionTextColor: AppColors.accent,
      insetPadding: const EdgeInsets.all(AppDimens.spaceLg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.toastRadius),
      ),
    ),
  );
}
