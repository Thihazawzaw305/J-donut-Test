import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Placeholder brand block: pink circle with the app name.
class OnboardingLogoPlaceholder extends StatelessWidget {
  const OnboardingLogoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppDimens.onboardingLogoSize,
        height: AppDimens.onboardingLogoSize,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.heroPink,
          shape: BoxShape.circle,
        ),
        child: Text(
          context.l10n.appName,
          style: AppTextStyles.headline.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
