import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class RewardsPillButton extends StatelessWidget {
  const RewardsPillButton({
    super.key,
    required this.label,
    required this.count,
    required this.badgeScale,
    required this.onPressed,
  });

  final String label;
  final int count;
  final double badgeScale;
  final VoidCallback onPressed;

  static const _pillShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(AppDimens.rewardsPillRadius),
    ),
    side: BorderSide(
      color: AppColors.onPrimary,
      width: AppDimens.rewardsPillBorderWidth,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.notificationOrange,
      shape: _pillShape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: _pillShape,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.rewardsPillPaddingH,
            AppDimens.rewardsPillPaddingV,
            AppDimens.rewardsPillPaddingH,
            AppDimens.rewardsPillPaddingV,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Transform.scale(
                scale: badgeScale,
                alignment: Alignment.center,
                child: Container(
                  width: AppDimens.rewardsPillCountBadgeSize,
                  height: AppDimens.rewardsPillCountBadgeSize,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.onPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: AppTextStyles.bodyBold.copyWith(
                      fontSize: 10,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
