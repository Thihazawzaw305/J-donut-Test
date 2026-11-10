import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/legal_footer.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/pump_jdonuts_app.dart';

Future<void> pumpToast(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('does not show a headline above the actions', (tester) async {
    await pumpJDonutsApp(tester);
    expect(find.text('Round food for every mood'), findsNothing);
  });

  testWidgets('first launch shows onboarding with brand and actions', (
    tester,
  ) async {
    await pumpJDonutsApp(tester);

    expect(find.byKey(const Key('onboarding_hero_image')), findsNothing);
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
  });

  testWidgets('bottom entrance starts without hero background', (tester) async {
    await pumpJDonutsApp(tester, settle: false, disableAnimations: false);
    await tester.pump();
    final headline = find.text("LET'S GET STARTED");
    expect(headline, findsOneWidget);
    final opacityAtStart = tester.widget<Opacity>(
      find.ancestor(of: headline, matching: find.byType(Opacity)).first,
    );
    expect(opacityAtStart.opacity, 0);

    await tester.pump(AppMotion.onboardingBottomDelay);
    await tester.pump(const Duration(milliseconds: 100));
    final opacityMid = tester.widget<Opacity>(
      find.ancestor(of: headline, matching: find.byType(Opacity)),
    );
    expect(opacityMid.opacity, greaterThan(0));
  });

  testWidgets('shows hero donuts and a bottom gradient backdrop', (
    tester,
  ) async {
    await pumpJDonutsApp(tester);

    for (var i = 0; i < 5; i++) {
      expect(find.byKey(ValueKey('onboarding_donut_$i')), findsOneWidget);
    }
    expect(find.byKey(const Key('onboarding_bottom_gradient')), findsOneWidget);
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

    await tester.ensureVisible(find.byTooltip('Continue with Google'));
    await tester.tap(find.byTooltip('Continue with Google'));
    await pumpToast(tester);
    expect(find.text('Coming soon'), findsOneWidget);

    await tester.ensureVisible(find.byTooltip('Continue with Apple'));
    await tester.tap(find.byTooltip('Continue with Apple'));
    await pumpToast(tester);
    expect(find.text('Coming soon'), findsOneWidget);

    await tester.ensureVisible(find.byTooltip('Continue with Facebook'));
    await tester.tap(find.byTooltip('Continue with Facebook'));
    await pumpToast(tester);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Terms of Use shows a coming soon toast', (tester) async {
    await pumpJDonutsApp(tester);

    await tester.ensureVisible(find.byType(LegalFooter));
    await tester.tapOnText(find.textRange.ofSubstring('Terms of Use'));
    await pumpToast(tester);

    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Privacy Policy shows a coming soon toast', (tester) async {
    await pumpJDonutsApp(tester);

    await tester.ensureVisible(find.byType(LegalFooter));
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
