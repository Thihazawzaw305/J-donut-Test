import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';

/// Donut ring in the top-right of each registration step.
///
/// When [showCheck] is set the ring fills first, then the check draws in.
class StepProgressRing extends StatelessWidget {
  const StepProgressRing({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.showCheck = false,
  });

  final int currentStep;
  final int totalSteps;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final ring = AppMotion.of(context, AppMotion.long);
    final check = showCheck
        ? AppMotion.of(context, AppMotion.stepCheckDraw)
        : Duration.zero;
    final total = ring + check;
    final ringFraction = total == Duration.zero
        ? 1.0
        : ring.inMilliseconds / total.inMilliseconds;
    final begin = (currentStep - 1) / totalSteps;
    final end = currentStep / totalSteps;

    return Semantics(
      label: context.l10n.stepProgress(currentStep, totalSteps),
      child: SizedBox.square(
        dimension: AppDimens.progressRingSize,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: total,
          builder: (context, t, _) {
            final ringT = Interval(
              0,
              ringFraction,
              curve: AppMotion.standardCurve,
            ).transform(t);
            final checkT = showCheck && ringFraction < 1
                ? Interval(
                    ringFraction,
                    1,
                    curve: AppMotion.standardCurve,
                  ).transform(t)
                : (showCheck ? 1.0 : 0.0);
            return CustomPaint(
              painter: StepProgressPainter(
                progress: begin + (end - begin) * ringT,
                showCheck: showCheck,
                checkProgress: checkT,
              ),
            );
          },
        ),
      ),
    );
  }
}

class StepProgressPainter extends CustomPainter {
  StepProgressPainter({
    required this.progress,
    this.showCheck = false,
    this.checkProgress = 0,
  });

  static const _startAngle = -math.pi / 2;
  static const _fullTurn = 2 * math.pi;
  static const _checkStrokeWidth = 2.5;
  static const _checkScale = 0.9;

  final double progress;
  final bool showCheck;

  /// 0 = ring only, 1 = filled disc with the full check.
  final double checkProgress;

  bool get showsCompletedCheck =>
      showCheck && progress >= 1.0 && checkProgress >= 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = AppDimens.progressRingStroke;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final center = rect.center;
    final radius = rect.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(
      rect,
      0,
      _fullTurn,
      false,
      paint..color = AppColors.ringTrack,
    );
    canvas.drawArc(
      rect,
      _startAngle,
      _fullTurn * progress,
      false,
      paint..color = AppColors.ringProgress,
    );
    if (checkProgress > 0) _paintCheckMorph(canvas, center, radius);
  }

  void _paintCheckMorph(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.ringProgress.withValues(alpha: checkProgress)
        ..style = PaintingStyle.fill,
    );
    final scale = radius * _checkScale;
    final path = Path()
      ..moveTo(center.dx - scale * 0.35, center.dy)
      ..lineTo(center.dx - scale * 0.05, center.dy + scale * 0.3)
      ..lineTo(center.dx + scale * 0.4, center.dy - scale * 0.35);
    final drawn = Path();
    for (final metric in path.computeMetrics()) {
      drawn.addPath(
        metric.extractPath(0, metric.length * checkProgress),
        Offset.zero,
      );
    }
    canvas.drawPath(
      drawn,
      Paint()
        ..color = AppColors.onPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = _checkStrokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(StepProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.showCheck != showCheck ||
      oldDelegate.checkProgress != checkProgress;
}
