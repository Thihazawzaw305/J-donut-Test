import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/rewards_tier.dart';
import '../../domain/rewards_tier_assets.dart';
import 'rewards_tier_connector.dart';

class RewardsTierStep extends StatelessWidget {
  const RewardsTierStep({
    super.key,
    required this.tier,
    required this.title,
    required this.subtitle,
    required this.reached,
    required this.fade,
    required this.slide,
    this.showConnectorBelow = false,
    this.belowConnectorFill = 0,
  });

  final RewardsTier tier;
  final String title;
  final String subtitle;
  final bool reached;
  final double fade;
  final double slide;
  final bool showConnectorBelow;
  final double belowConnectorFill;

  static List<double> _desaturateMatrix(double amount) {
    const r = 0.2126;
    const g = 0.7152;
    const b = 0.0722;
    final keep = 1 - amount;
    return [
      keep + amount * r,
      amount * g,
      amount * b,
      0,
      0,
      amount * r,
      keep + amount * g,
      amount * b,
      0,
      0,
      amount * r,
      amount * g,
      keep + amount * b,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  ColorFilter? get _lockedBadgeColorFilter {
    if (reached) return null;
    return switch (tier) {
      RewardsTier.gold => ColorFilter.matrix(
        _desaturateMatrix(AppDimens.rewardsTierLockedDesaturateGold),
      ),
      RewardsTier.platinum => ColorFilter.matrix(
        _desaturateMatrix(AppDimens.rewardsTierLockedDesaturatePlatinum),
      ),
      RewardsTier.silver => null,
    };
  }

  double get _stepOpacity {
    if (reached) return 1;
    return switch (tier) {
      RewardsTier.gold => AppDimens.rewardsTierLockedOpacityGold,
      RewardsTier.platinum => AppDimens.rewardsTierLockedOpacityPlatinum,
      RewardsTier.silver => 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    final badge = Image.asset(
      rewardsTierBadgeAssets[tier]!,
      width: AppDimens.rewardsTierBadgeSize,
      height: AppDimens.rewardsTierBadgeSize,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => SizedBox.square(
        dimension: AppDimens.rewardsTierBadgeSize,
        child: ColoredBox(color: AppColors.tierCapsuleBorder),
      ),
    );

    final lockedFilter = _lockedBadgeColorFilter;
    final badgeWidget = lockedFilter == null
        ? badge
        : ColorFiltered(colorFilter: lockedFilter, child: badge);

    return Opacity(
      opacity: fade * _stepOpacity,
      child: Transform.translate(
        offset: Offset(-slide, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: AppDimens.rewardsTierBadgeSize,
                  height: AppDimens.rewardsTierBadgeSize,
                  child: Center(child: badgeWidget),
                ),
                if (showConnectorBelow)
                  RewardsTierConnector(fill: belowConnectorFill),
              ],
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
