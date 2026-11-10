import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/welcome_hero_gradient_overlay.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows welcome headline hero and gradient', (tester) async {
    await tester.pumpApp(const WelcomePage());
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome to the'), findsOneWidget);
    expect(find.text("LET'S EXPLORE"), findsOneWidget);
    expect(find.byKey(const Key('welcome_hero_image')), findsNothing);
    expect(find.byType(Image), findsNWidgets(4));
    expect(find.byKey(WelcomeHeroGradientOverlay.overlayKey), findsOneWidget);

    final overlayBox = tester.renderObject<RenderBox>(
      find.byKey(WelcomeHeroGradientOverlay.overlayKey),
    );
    final viewportHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(
      overlayBox.size.height,
      closeTo(
        viewportHeight * WelcomeHeroGradientOverlay.viewportHeightFraction,
        1,
      ),
    );
  });

  testWidgets('gradient overlay reads colors from AppColors tokens', (
    tester,
  ) async {
    await tester.pumpApp(const WelcomePage());
    await tester.pumpAndSettle();

    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byKey(WelcomeHeroGradientOverlay.overlayKey),
        matching: find.byType(DecoratedBox),
      ),
    );
    final gradient =
        (box.decoration as BoxDecoration).gradient! as LinearGradient;
    expect(gradient.colors, AppColors.welcomeScrimColors);
  });

  testWidgets('narrow viewport with large text does not overflow', (
    tester,
  ) async {
    await tester.pumpApp(
      const MediaQuery(
        data: MediaQueryData(
          size: Size(320, 568),
          textScaler: TextScaler.linear(1.3),
        ),
        child: WelcomePage(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
