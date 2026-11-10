import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_challenge_entrance.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('cards start off-screen left before entrance completes', (
    tester,
  ) async {
    final controller = AnimationController(
      vsync: tester,
      duration: const Duration(milliseconds: 1400),
    );
    addTearDown(controller.dispose);

    await tester.pumpApp(
      AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return RewardsChallengeEntrance(
            entrance: controller,
            index: 0,
            child: const SizedBox(width: 200, height: 40),
          );
        },
      ),
    );

    controller.value = 0;
    await tester.pump();

    final entrance = find.byType(RewardsChallengeEntrance);
    final opacity = tester.widget<Opacity>(
      find.descendant(of: entrance, matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, 0);

    final transform = tester.widget<Transform>(
      find.descendant(of: entrance, matching: find.byType(Transform)),
    );
    expect(transform.transform.getTranslation().x, lessThan(0));

    controller.value = 1;
    await tester.pump();

    final opacityDone = tester.widget<Opacity>(
      find.descendant(of: entrance, matching: find.byType(Opacity)),
    );
    expect(opacityDone.opacity, 1);
    final transformDone = tester.widget<Transform>(
      find.descendant(of: entrance, matching: find.byType(Transform)),
    );
    expect(transformDone.transform.getTranslation().x, 0);
  });
}
