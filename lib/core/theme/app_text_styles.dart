import 'package:flutter/painting.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

abstract final class AppTextStyles {
  static const fontFamily = 'Urbanist';

  static const headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  static const homeSectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppDimens.homeSectionTitleSize,
    fontWeight: FontWeight.w800,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  static const homeMemberName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  static const homeTierPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const bodyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
  static const homeShopCardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w800,
    height: 1.3,
    color: AppColors.textPrimary,
  );
  static const link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
  static const input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
  );
  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.4,
    color: AppColors.onPrimary,
  );
  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textMuted,
  );
  static const captionLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.accent,
  );
  static const toast = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );
  static const brand = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
  );
  static const error = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.error,
  );
}
