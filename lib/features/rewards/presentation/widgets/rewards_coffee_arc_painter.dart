import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';

/// Semi-circular arch (open at the bottom) behind the coffee image.
class RewardsCoffeeArcPainter extends CustomPainter {
  const RewardsCoffeeArcPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppDimens.rewardsCoffeeArcStroke;
    final inset = stroke / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - stroke,
      size.height - stroke,
    );

    final track = Paint()
      ..color = AppColors.rewardsCoffeeArcTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = AppColors.rewardsCoffeeArc
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    const start = AppDimens.rewardsCoffeeArcStart;
    const span = AppDimens.rewardsCoffeeArcSweep;

    canvas.drawArc(rect, start, span, false, track);

    final clamped = progress.clamp(0.0, 1.0);
    if (clamped > 0) {
      canvas.drawArc(rect, start, span * clamped, false, fill);
    }
  }

  @override
  bool shouldRepaint(RewardsCoffeeArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
