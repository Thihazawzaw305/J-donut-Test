import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';

class RewardsTierConnector extends StatelessWidget {
  const RewardsTierConnector({super.key, required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    final clamped = fill.clamp(0.0, 1.0);

    return SizedBox(
      width: AppDimens.rewardsTierBadgeSize,
      height: AppDimens.rewardsTierConnectorHeight,
      child: Center(
        child: CustomPaint(
          size: const Size(
            AppDimens.rewardsTierConnectorWidth,
            AppDimens.rewardsTierConnectorHeight,
          ),
          painter: _RewardsTierConnectorPainter(progress: clamped),
        ),
      ),
    );
  }
}

class _RewardsTierConnectorPainter extends CustomPainter {
  _RewardsTierConnectorPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final track = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(AppDimens.rewardsTierConnectorWidth),
    );
    canvas.drawRRect(track, Paint()..color = AppColors.rewardsConnectorTrack);

    if (progress <= 0) return;

    final fillHeight = size.height * progress;
    final fillRect = Rect.fromLTWH(0, 0, size.width, fillHeight);
    final fillRrect = RRect.fromRectAndRadius(
      fillRect,
      const Radius.circular(AppDimens.rewardsTierConnectorWidth),
    );
    canvas.drawRRect(
      fillRrect,
      Paint()..color = AppColors.rewardsConnectorFill,
    );
  }

  @override
  bool shouldRepaint(covariant _RewardsTierConnectorPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
