import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  double paintedProgress(WidgetTester tester) {
    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(StepProgressRing),
        matching: find.byType(CustomPaint),
      ),
    );
    return (paint.painter! as StepProgressPainter).progress;
  }

  testWidgets('animates from the previous step to the current step', (
    tester,
  ) async {
    await tester.pumpApp(const StepProgressRing(currentStep: 2, totalSteps: 4));
    expect(paintedProgress(tester), 0.25);

    await tester.pumpAndSettle();
    expect(paintedProgress(tester), 0.5);
  });

  testWidgets('jumps straight to the current step when motion is reduced', (
    tester,
  ) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: const StepProgressRing(currentStep: 1, totalSteps: 4),
        ),
      ),
    );

    expect(paintedProgress(tester), 0.25);
  });

  testWidgets('announces the step to screen readers', (tester) async {
    await tester.pumpApp(const StepProgressRing(currentStep: 1, totalSteps: 4));

    expect(find.bySemanticsLabel('Step 1 of 4'), findsOneWidget);
  });

  testWidgets('paints completed check when showCheck is true', (tester) async {
    await tester.pumpApp(
      const StepProgressRing(
        currentStep: 4,
        totalSteps: 4,
        showCheck: true,
      ),
    );

    await tester.pumpAndSettle();
    final painter = tester
        .widget<CustomPaint>(
          find.descendant(
            of: find.byType(StepProgressRing),
            matching: find.byType(CustomPaint),
          ),
        )
        .painter! as StepProgressPainter;
    expect(painter.progress, 1);
    expect(painter.showCheck, isTrue);
    expect(painter.showsCompletedCheck, isTrue);
  });
}
