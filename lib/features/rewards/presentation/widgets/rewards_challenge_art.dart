import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../catalog/domain/entities/catalog_challenge.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';
import 'rewards_coffee_arc_painter.dart';
import 'rewards_donut_quarter_clipper.dart';

class RewardsChallengeArt extends StatelessWidget {
  const RewardsChallengeArt({
    super.key,
    required this.challenge,
    required this.progress,
  });

  final CatalogChallenge challenge;
  final double progress;

  static const _donutColorAsset =
      'assets/images/seed/rewards/challenge_coco_full.jpg';

  @override
  Widget build(BuildContext context) {
    if (challenge.kind != CatalogChallengeKind.coffee) {
      return ClipOval(
        child: SizedBox(
          width: AppDimens.rewardsChallengeImageSize,
          height: AppDimens.rewardsChallengeImageSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColorFiltered(
                colorFilter: ColorFilter.matrix(<double>[
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: CatalogImage(asset: _donutColorAsset, fit: BoxFit.cover),
              ),
              ClipPath(
                clipper: RewardsDonutQuarterClipper(progress: progress),
                child: const CatalogImage(
                  asset: _donutColorAsset,
                  fit: BoxFit.cover,
                ),
              ),
              CustomPaint(
                painter: _RewardsDonutQuarterOutlinePainter(progress: progress),
              ),
            ],
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

class _RewardsDonutQuarterOutlinePainter extends CustomPainter {
  const _RewardsDonutQuarterOutlinePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = AppColors.rewardsDonutFrosting.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide / 2 - 1,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RewardsDonutQuarterOutlinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
