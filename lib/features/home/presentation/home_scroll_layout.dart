import 'package:flutter/widgets.dart';

import '../../../core/constants/app_dimens.dart';

/// Pink accent band behind the floating nav (`HomeBottomNavAccentStrip`).
double homeNavAccentHeight(BuildContext context) {
  return AppDimens.homeNavHeight / 2 + MediaQuery.paddingOf(context).bottom;
}

/// Scrollable inset so content does not sit under [HomeShell] floating nav + accent.
double homeScrollBottomClearance(BuildContext context) {
  return AppDimens.spaceSm +
      AppDimens.homeNavHeight +
      homeNavAccentHeight(context) +
      AppDimens.homeNavContentGap;
}

/// Inset below shop cards: nav overlay only (pink tail is separate below scenery).
double homeShopsScrollPadBelowCards(BuildContext context) {
  final total = homeScrollBottomClearance(context);
  final accent = homeNavAccentHeight(context);
  return (total - accent).clamp(0.0, double.infinity);
}
