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
  });

  final int currentStep;
  final int totalSteps;

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
          builder: (context, progress, _) =>
              CustomPaint(painter: StepProgressPainter(progress: progress)),
        ),
      ),
    );
  }
}

class StepProgressPainter extends CustomPainter {
  StepProgressPainter({required this.progress});

  static const _startAngle = -math.pi / 2;
  static const _fullTurn = 2 * math.pi;

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = AppDimens.progressRingStroke;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(rect, 0, _fullTurn, false, paint..color = AppColors.ringTrack);
    canvas.drawArc(
      rect,
      _startAngle,
      _fullTurn * progress,
      false,
      paint..color = AppColors.ringProgress,
    );
  }

  @override
  bool shouldRepaint(StepProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
