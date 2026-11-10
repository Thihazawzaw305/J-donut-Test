import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'rewards_pill_button.dart';

class RewardsHeroRow extends StatelessWidget {
  const RewardsHeroRow({
    super.key,
    required this.pillCount,
    required this.badgeScale,
    required this.titleFade,
    required this.titleSlide,
    required this.pillFade,
    required this.pillSlide,
    required this.onPillPressed,
  });

  final int pillCount;
  final double badgeScale;
  final double titleFade;
  final double titleSlide;
  final double pillFade;
  final double pillSlide;
  final VoidCallback onPillPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        AppDimens.rewardsHeroTopPadding,
        0,
        AppDimens.spaceMd,
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: titleFade,
              child: Transform.translate(
                offset: Offset(-titleSlide, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: AppDimens.spaceLg),
                  child: Text(
                    context.l10n.rewardsScreenTitle,
                    style: AppTextStyles.headline.copyWith(
                      fontSize: AppDimens.rewardsScreenTitleSize,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Opacity(
              opacity: pillFade,
              child: Transform.translate(
                offset: Offset(pillSlide, 0),
                child: RewardsPillButton(
                  label: context.l10n.rewardsPillLabel,
                  count: pillCount,
                  badgeScale: badgeScale,
                  onPressed: onPillPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
