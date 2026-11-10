import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/pump_jdonuts_app.dart';

Future<void> pumpToast(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(AppMotion.toastDisplay + const Duration(milliseconds: 300));
}

void main() {
  testWidgets('shows onboarding headline', (tester) async {
    await pumpJDonutsApp(tester);
    expect(find.text('Round food for every mood'), findsOneWidget);
  });

  testWidgets('first launch shows onboarding with brand and actions', (
    tester,
  ) async {
    await pumpJDonutsApp(tester);

    expect(find.byKey(const Key('onboarding_hero_image')), findsOneWidget);
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
  });

  testWidgets('bottom entrance starts after hero slide gate', (tester) async {
    await pumpJDonutsApp(tester, settle: false);
    await tester.pump();
    final headline = find.text('Round food for every mood');
    expect(headline, findsOneWidget);
    final opacityAtStart = tester.widget<Opacity>(
      find.ancestor(of: headline, matching: find.byType(Opacity)),
    );
    expect(opacityAtStart.opacity, 0);

    await tester.pump(AppMotion.onboardingSlide * 0.8);
    await tester.pump(AppMotion.onboardingBottomDelay);
    await tester.pump(const Duration(milliseconds: 100));
    final opacityMid = tester.widget<Opacity>(
      find.ancestor(of: headline, matching: find.byType(Opacity)),
    );
    expect(opacityMid.opacity, greaterThan(0));
  });

  testWidgets("Let's get started opens registration step 1", (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.byType(StepProgressRing), findsOneWidget);
  });

  testWidgets('Log In opens the phone step without a progress ring', (
    tester,
  ) async {
    await pumpJDonutsApp(tester);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.byType(StepProgressRing), findsNothing);
  });

  testWidgets('social sign-in buttons show a coming soon toast', (
    tester,
  ) async {
    await pumpJDonutsApp(tester);

    await tester.tap(find.byTooltip('Continue with Google'));
    await pumpToast(tester);
    expect(find.text('Coming soon'), findsOneWidget);

    await tester.tap(find.byTooltip('Continue with Facebook'));
    await pumpToast(tester);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Terms of Use shows a coming soon toast', (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tapOnText(find.textRange.ofSubstring('Terms of Use'));
    await pumpToast(tester);

    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Privacy Policy shows a coming soon toast', (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tapOnText(find.textRange.ofSubstring('Privacy Policy'));
    await pumpToast(tester);

    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('fits a narrow screen with large text', (tester) async {
    const viewport = Size(320, 568);
    await pumpJDonutsApp(tester, viewport: viewport, textScale: 1.3);

    expect(find.text("LET'S GET STARTED"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
