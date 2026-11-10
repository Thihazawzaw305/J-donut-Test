import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/animated_input_shell.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  Color borderColor(WidgetTester tester) {
    // Rendered (interpolated) decoration, not the animation target.
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(AnimatedInputShell),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = box.decoration as BoxDecoration;
    return (decoration.border! as Border).top.color;
  }

  Widget shell({bool hasError = false}) =>
      AnimatedInputShell(hasError: hasError, child: const TextField());

  testWidgets('idle border is transparent', (tester) async {
    await tester.pumpApp(shell());

    expect(borderColor(tester), AppColors.inputBorderIdle);
  });

  testWidgets('border animates to the focus colour when the input is focused', (
    tester,
  ) async {
    await tester.pumpApp(shell());

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.pump(AppMotion.short ~/ 2);
    expect(borderColor(tester), isNot(AppColors.inputBorderIdle));
    expect(borderColor(tester), isNot(AppColors.inputBorderFocused));

    await tester.pumpAndSettle();
    expect(borderColor(tester), AppColors.inputBorderFocused);
  });

  testWidgets('border returns to idle when focus is lost', (tester) async {
    await tester.pumpApp(shell());
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    expect(borderColor(tester), AppColors.inputBorderIdle);
  });

  testWidgets('error colour wins over focus and animates in', (tester) async {
    await tester.pumpApp(shell());
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    await tester.pumpApp(shell(hasError: true));
    await tester.pump();
    await tester.pump(AppMotion.short ~/ 2);
    expect(borderColor(tester), isNot(AppColors.inputBorderFocused));

    await tester.pumpAndSettle();
    expect(borderColor(tester), AppColors.error);
  });

  testWidgets('snaps to the error colour when motion is reduced', (
    tester,
  ) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: shell(hasError: true),
        ),
      ),
    );

    expect(borderColor(tester), AppColors.error);
  });
}
