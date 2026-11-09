import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class CreatingOverlay extends StatelessWidget {
  const CreatingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.creating;
    return AbsorbPointer(
      child: Center(
        child: Semantics(
          liveRegion: true,
          label: label,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: AppDimens.shadowBlur,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceMd,
              ),
              child: Text(label, style: AppTextStyles.body),
            ),
          ),
        ),
      ),
    );
  }
}
