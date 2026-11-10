import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/onboarding_hero_image.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  const viewport = Size(400, 600);

  Future<void> pumpAtProgress(
    WidgetTester tester,
    double progress, {
    bool disableAnimations = false,
  }) async {
    final slide = _FixedSlideProgress(progress);

    await tester.pumpApp(
      MediaQuery(
        data: MediaQueryData(
          size: viewport,
          disableAnimations: disableAnimations,
        ),
        child: OnboardingHeroImage(slideProgress: slide),
      ),
    );
    await tester.pump();
  }

  testWidgets('hero is full viewport height at slide progress 0', (tester) async {
    await pumpAtProgress(tester, 0);
    final box = tester.renderObject<RenderBox>(
      find.byKey(const Key('onboarding_hero_image')),
    );
    expect(box.size.height, viewport.height);
  });

  testWidgets('hero band is half viewport at slide progress 1', (tester) async {
    await pumpAtProgress(tester, 1);
    final box = tester.renderObject<RenderBox>(
      find.byKey(const Key('onboarding_hero_image')),
    );
    expect(box.size.height, closeTo(viewport.height * 0.5, 1));
  });

  testWidgets('image shifts up when slide completes', (tester) async {
    await pumpAtProgress(tester, 0);
    final y0 = tester.getTopLeft(find.byType(Image)).dy;
    await pumpAtProgress(tester, 1);
    final y1 = tester.getTopLeft(find.byType(Image)).dy;
    final expectedShift = viewport.height * (1 - AppMotion.onboardingHeroSettledFraction);
    expect(y0 - y1, closeTo(expectedShift, 1));
  });

  testWidgets('reduce motion snaps image to settled offset', (tester) async {
    await pumpAtProgress(tester, 0, disableAnimations: true);
    final y = tester.getTopLeft(find.byType(Image)).dy;
    final expectedShift = viewport.height * (1 - AppMotion.onboardingHeroSettledFraction);
    expect(y, closeTo(-expectedShift, 1));
  });
}

class _FixedSlideProgress extends Animation<double> {
  _FixedSlideProgress(this.value);

  @override
  final double value;

  @override
  AnimationStatus get status => AnimationStatus.completed;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}
}
