import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';

/// Sprinkle on the frosting: [t] 0–1 on the arc, [radial] −1 inner / 1 outer,
/// [tilt] rotation from the radial axis (mock sprinkles sit across the tube).
typedef _Sprinkle = ({double t, double radial, double tilt, double scale});

class RewardsDonutRingPainter extends CustomPainter {
  RewardsDonutRingPainter({required this.progress});

  final double progress;

  static const _sprinkles = <_Sprinkle>[
    (t: 0.08, radial: 0.05, tilt: 0.35, scale: 1),
    (t: 0.16, radial: -0.18, tilt: -0.45, scale: 0.9),
    (t: 0.24, radial: 0.22, tilt: 0.15, scale: 1.05),
    (t: 0.33, radial: -0.08, tilt: 0.55, scale: 0.95),
    (t: 0.41, radial: 0.28, tilt: -0.25, scale: 1.1),
    (t: 0.50, radial: -0.22, tilt: 0.20, scale: 0.88),
    (t: 0.58, radial: 0.10, tilt: -0.50, scale: 1),
    (t: 0.66, radial: 0.30, tilt: 0.40, scale: 0.92),
    (t: 0.74, radial: -0.12, tilt: -0.18, scale: 1.08),
    (t: 0.82, radial: 0.18, tilt: 0.48, scale: 0.9),
    (t: 0.90, radial: -0.05, tilt: -0.32, scale: 1),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = AppDimens.rewardsDonutStroke;
    final radius = (size.shortestSide - stroke) / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius - stroke / 2,
      Paint()..color = AppColors.surface,
    );

    canvas.drawArc(
      arcRect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = AppColors.rewardsDonutTrack
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );

    final sweep = math.pi *
        2 *
        progress.clamp(0, 1) *
        AppDimens.rewardsDonutSweepSign;
    if (sweep == 0) return;

    const start = AppDimens.rewardsDonutArcStart;
    _drawFrostingTube(
      canvas,
      rect: arcRect,
      center: center,
      radius: radius,
      stroke: stroke,
      start: start,
      sweep: sweep,
    );
    _drawSprinkles(
      canvas,
      center: center,
      radius: radius,
      stroke: stroke,
      start: start,
      sweep: sweep,
    );
  }

  void _drawFrostingTube(
    Canvas canvas, {
    required Rect rect,
    required Offset center,
    required double radius,
    required double stroke,
    required double start,
    required double sweep,
  }) {
    Paint strokePaint(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      strokePaint(AppColors.rewardsDonutFrostingLo, stroke),
    );
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      strokePaint(AppColors.rewardsDonutFrosting, stroke * 0.86),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - stroke * 0.06),
      start,
      sweep,
      false,
      strokePaint(AppColors.rewardsDonutFrostingMid, stroke * 0.58),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - stroke * 0.12),
      start,
      sweep,
      false,
      strokePaint(AppColors.rewardsDonutFrostingHi, stroke * 0.28),
    );
  }

  void _drawSprinkles(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double stroke,
    required double start,
    required double sweep,
  }) {
    final paint = Paint()..color = AppColors.rewardsDonutSprinkle;
    final baseLength = AppDimens.rewardsDonutSprinkleLength;
    final thickness = AppDimens.rewardsDonutSprinkleThickness;

    for (final sprinkle in _sprinkles) {
      if (sprinkle.t > progress.clamp(0, 1)) continue;

      final angle = start + sweep * sprinkle.t;
      final ringR = radius + sprinkle.radial * stroke * 0.22;
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * ringR;
      final length = baseLength * sprinkle.scale;
      final capsule = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: length,
          height: thickness,
        ),
        Radius.circular(thickness / 2),
      );

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle + sprinkle.tilt);
      canvas.drawRRect(capsule, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant RewardsDonutRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
