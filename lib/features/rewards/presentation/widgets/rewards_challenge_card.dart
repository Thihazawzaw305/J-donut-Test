import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../catalog/domain/entities/catalog_challenge.dart';
import '../../../catalog/presentation/catalog_strings.dart';
import '../../domain/rewards_challenge.dart';
import 'rewards_challenge_art.dart';
import 'rewards_earn_button.dart';

class RewardsChallengeCard extends StatelessWidget {
  const RewardsChallengeCard({super.key, required this.challenge});

  final CatalogChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final enabled = challengeEarnEnabled(
      current: challenge.progressCurrent,
      total: challenge.progressTotal,
    );
    final fraction = challengeProgressFraction(
      current: challenge.progressCurrent,
      total: challenge.progressTotal,
    );

    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(AppDimens.rewardsChallengeCardRadius),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.rewardsChallengeCardPadding),
        child: Row(
          children: [
            RewardsChallengeArt(challenge: challenge, progress: fraction),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    catalogString(l10n, challenge.titleKey),
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    l10n.rewardsChallengeProgress(
                      challenge.progressCurrent,
                      challenge.progressTotal,
                    ),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  Row(
                    children: [
                      RewardsEarnButton(enabled: enabled),
                      const SizedBox(width: AppDimens.spaceSm),
                      Text(
                        l10n.rewardsPtsLabel(challenge.pointsReward),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
