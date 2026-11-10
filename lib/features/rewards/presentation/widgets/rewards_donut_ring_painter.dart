import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';

/// [t] progress along filled arc; [radial] −1..1 inner..outer frosting;
/// [rotation] absolute radians (not tied to arc angle).
typedef _Sprinkle = ({double t, double radial, double rotation, double scale});

class RewardsDonutRingPainter extends CustomPainter {
  RewardsDonutRingPainter({required this.progress});

  final double progress;

  static const _sprinkleSeed = 17;
  static final List<_Sprinkle> _sprinkles = _generateSprinkles();

  static List<_Sprinkle> _generateSprinkles() {
    final random = math.Random(_sprinkleSeed);
    return List.generate(AppDimens.rewardsDonutSprinkleCount, (_) {
      return (
        t: random.nextDouble(),
        radial: random.nextDouble() * 2 - 1,
        rotation: random.nextDouble() * 2 * math.pi,
        scale: 0.85 + random.nextDouble() * 0.22,
      );
    });
  }

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

    final sweep =
        math.pi *
        2 *
        progress.clamp(0, AppDimens.rewardsDonutDisplaySweep) *
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
    final bandHalf = stroke / 2 - AppDimens.rewardsDonutSprinkleEdgeInset;
    final arcSpan = AppDimens.rewardsDonutDisplaySweep;
    final fillAlongArc = (progress.clamp(0, arcSpan) / arcSpan).clamp(0.0, 1.0);

    for (final sprinkle in _sprinkles) {
      if (sprinkle.t > fillAlongArc) continue;

      final angle = start + sweep * sprinkle.t;
      final ringR = radius + sprinkle.radial * bandHalf;
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * ringR;
      final length = baseLength * sprinkle.scale;
      final capsule = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: length, height: thickness),
        Radius.circular(thickness / 2),
      );

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(sprinkle.rotation);
      canvas.drawRRect(capsule, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant RewardsDonutRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
