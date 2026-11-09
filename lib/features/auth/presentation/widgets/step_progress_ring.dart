import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';

/// Donut ring in the top-right of each registration step.
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
    return Semantics(
      label: context.l10n.stepProgress(currentStep, totalSteps),
      child: SizedBox.square(
        dimension: AppDimens.progressRingSize,
        child: TweenAnimationBuilder<double>(
          tween: Tween(
            begin: (currentStep - 1) / totalSteps,
            end: currentStep / totalSteps,
          ),
          duration: AppMotion.of(context, AppMotion.long),
          curve: AppMotion.standardCurve,
          builder: (context, progress, _) => CustomPaint(
            painter: StepProgressPainter(
              progress: progress,
              showCheck: showCheck,
            ),
          ),
        ),
      ),
    );
  }
}

class StepProgressPainter extends CustomPainter {
  StepProgressPainter({required this.progress, this.showCheck = false});

  static const _startAngle = -math.pi / 2;
  static const _fullTurn = 2 * math.pi;

  final double progress;
  final bool showCheck;

  bool get showsCompletedCheck => showCheck && progress >= 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = AppDimens.progressRingStroke;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final center = rect.center;
    final radius = rect.width / 2;

    if (showsCompletedCheck) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = AppColors.ringProgress
          ..style = PaintingStyle.fill,
      );
      _paintCheck(canvas, center, radius);
      return;
    }

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
  }

  void _paintCheck(Canvas canvas, Offset center, double radius) {
    final scale = radius * 0.9;
    final path = Path()
      ..moveTo(center.dx - scale * 0.35, center.dy)
      ..lineTo(center.dx - scale * 0.05, center.dy + scale * 0.3)
      ..lineTo(center.dx + scale * 0.4, center.dy - scale * 0.35);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.onPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(StepProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.showCheck != showCheck;
}
