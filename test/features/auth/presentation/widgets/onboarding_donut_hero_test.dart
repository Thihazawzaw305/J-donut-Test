import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/onboarding_donut_hero.dart';

const _size = Size(400, 800);

Future<void> pumpHero(WidgetTester tester, {bool reduceMotion = false}) {
  tester.view.physicalSize = _size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  return tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: _size, disableAnimations: reduceMotion),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: OnboardingDonutHero(logo: Text('LOGO')),
      ),
    ),
  );
}

Finder tile(int i) => find.byKey(ValueKey('onboarding_donut_$i'));

void main() {
  testWidgets('renders five tiles and the logo', (tester) async {
    await pumpHero(tester);
    for (var i = 0; i < 5; i++) {
      expect(tile(i), findsOneWidget);
    }
    expect(find.text('LOGO'), findsOneWidget);
  });

  testWidgets('tiles hold, then move up together keeping spacing', (
    tester,
  ) async {
    await pumpHero(tester);
    await tester.pump();
    final start = [for (var i = 0; i < 5; i++) tester.getCenter(tile(i))];

    await tester.pump(
      AppMotion.onboardingHeroHold + AppMotion.onboardingHeroMove,
    );
    final end = [for (var i = 0; i < 5; i++) tester.getCenter(tile(i))];

    final shift = end[0].dy - start[0].dy;
    expect(shift, lessThan(0));
    for (var i = 0; i < 5; i++) {
      expect(end[i].dy - start[i].dy, closeTo(shift, 0.01));
      expect(end[i].dx, start[i].dx);
    }
  });

  testWidgets('reduce motion shows the final layout immediately', (
    tester,
  ) async {
    await pumpHero(tester);
    await tester.pump(
      AppMotion.onboardingHeroHold + AppMotion.onboardingHeroMove,
    );
    final finalDy = tester.getCenter(tile(0)).dy;
    await tester.pumpWidget(const SizedBox());

    await pumpHero(tester, reduceMotion: true);
    await tester.pump();
    expect(tester.getCenter(tile(0)).dy, closeTo(finalDy, 0.01));
  });
}
