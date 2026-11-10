import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../catalog/domain/entities/catalog_challenge.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';
import 'rewards_coffee_arc_painter.dart';

class RewardsChallengeArt extends StatelessWidget {
  const RewardsChallengeArt({
    super.key,
    required this.challenge,
    required this.progress,
  });

  final CatalogChallenge challenge;
  final double progress;

  @override
  Widget build(BuildContext context) {
    if (challenge.kind != CatalogChallengeKind.coffee) {
      return ClipOval(
        child: SizedBox(
          width: AppDimens.rewardsChallengeImageSize,
          height: AppDimens.rewardsChallengeImageSize,
          child: CatalogImage(
            asset: challenge.imageAsset,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return SizedBox(
      width: AppDimens.rewardsCoffeeArtWidth,
      height: AppDimens.rewardsCoffeeArtHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: AppDimens.rewardsCoffeeArtHeight,
            child: CustomPaint(
              painter: RewardsCoffeeArcPainter(progress: progress),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppDimens.rewardsCoffeeImageRadius,
              ),
              child: SizedBox(
                width: AppDimens.rewardsCoffeeImageWidth,
                height: AppDimens.rewardsCoffeeImageHeight,
                child: CatalogImage(
                  asset: challenge.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
