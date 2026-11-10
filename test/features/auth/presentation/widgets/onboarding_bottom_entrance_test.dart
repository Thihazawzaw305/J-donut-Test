import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/onboarding_bottom_entrance.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('bottom stays hidden until beginEntrance', (tester) async {
    final key = GlobalKey<OnboardingBottomEntranceState>();
    await tester.pumpApp(
      OnboardingBottomEntrance(
        key: key,
        autoStart: false,
        children: const [Text('Visible copy')],
      ),
    );
    await tester.pump();
    expect(find.text('Visible copy'), findsOneWidget);
    final opacity = tester.widget<Opacity>(
      find.ancestor(
        of: find.text('Visible copy'),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 0);

    key.currentState!.beginEntrance();
    await tester.pump();
    await tester.pump(AppMotion.onboardingBottomDelay);
    await tester.pump(AppMotion.onboardingBottomEntrance);
    final opacityAfter = tester.widget<Opacity>(
      find.ancestor(
        of: find.text('Visible copy'),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacityAfter.opacity, greaterThan(0));
  });
}
