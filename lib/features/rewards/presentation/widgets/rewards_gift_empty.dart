import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class RewardsGiftEmpty extends StatelessWidget {
  const RewardsGiftEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.rewardsGiftEmpty,
        style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}
