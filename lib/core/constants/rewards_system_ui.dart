import 'package:flutter/services.dart';

import 'app_colors.dart';

/// Status bar on Rewards matches the upper off-white panel.
abstract final class RewardsSystemUi {
  static const overlayStyle = SystemUiOverlayStyle(
    statusBarColor: AppColors.rewardsBackgroundTop,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
  );

  static const homeOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: AppColors.homeScreenBackground,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
  );
}
