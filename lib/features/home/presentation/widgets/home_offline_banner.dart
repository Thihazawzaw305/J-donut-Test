import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeOfflineBanner extends StatelessWidget {
  const HomeOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textPrimary,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSm,
          ),
          child: Text(
            context.l10n.homeOfflineBanner,
            style: AppTextStyles.body.copyWith(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
