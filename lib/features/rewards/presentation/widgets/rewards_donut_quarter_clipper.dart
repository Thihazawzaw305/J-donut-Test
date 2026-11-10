import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Reveals filled donut art clockwise in quarter steps (0–1 progress).
class RewardsDonutQuarterClipper extends CustomClipper<Path> {
  const RewardsDonutQuarterClipper({required this.progress});

  final double progress;

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final path = Path();
    final filledQuarters = (progress.clamp(0.0, 1.0) * 4.0).clamp(0.0, 4.0);

    if (filledQuarters <= 0) {
      return path;
    }

    const quarterSweep = math.pi / 2;
    var startAngle = -math.pi / 2;
    var remaining = filledQuarters;

    for (var i = 0; i < 4 && remaining > 0; i++) {
      final sweep = math.min(remaining, 1.0) * quarterSweep;
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
      );
      path.close();
      startAngle += quarterSweep;
      remaining -= 1;
    }

    return path;
  }

  @override
  bool shouldReclip(covariant RewardsDonutQuarterClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
