import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/pump_jdonuts_app.dart';

void main() {
  testWidgets('first launch shows onboarding with brand and actions', (
    tester,
  ) async {
    await pumpJDonutsApp(tester);

    expect(find.text("J'Donuts"), findsOneWidget);
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
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
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);

    await tester.tap(find.byTooltip('Continue with Facebook'));
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Terms of Use shows a coming soon toast', (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tapOnText(find.textRange.ofSubstring('Terms of Use'));
    await tester.pumpAndSettle();

    expect(find.text('Coming soon'), findsOneWidget);
  });
}
