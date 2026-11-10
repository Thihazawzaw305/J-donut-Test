import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('accent strip is full width and half nav height', (tester) async {
    const viewport = Size(400, 800);
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(size: viewport),
          child: Scaffold(
            bottomNavigationBar: SizedBox(
              height: 120,
              child: Stack(
                children: [
                  HomeBottomNavAccentStrip(),
                  HomeBottomNav(activeOverride: HomeShellTab.home),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final strip = find.byWidgetPredicate(
      (w) => w is ColoredBox && w.color == AppColors.accent,
    );
    expect(strip, findsOneWidget);

    final stripSize = tester.getSize(strip);
    expect(stripSize.height, AppDimens.homeNavHeight / 2);
    expect(stripSize.width, viewport.width);
  });

  testWidgets('cyan bar rounds top corners only', (tester) async {
    await tester.pumpApp(
      const HomeBottomNav(activeOverride: HomeShellTab.home),
    );

    final materialFinder = find.descendant(
      of: find.byType(HomeBottomNav),
      matching: find.byWidgetPredicate(
        (w) => w is Material && w.color == AppColors.homeNavBar,
      ),
    );
    expect(materialFinder, findsOneWidget);

    final material = tester.widget<Material>(materialFinder);
    expect(
      material.shape,
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.homeNavRadius),
        ),
      ),
    );
  });

  testWidgets('active home shows pill label Home', (tester) async {
    await tester.pumpApp(
      const HomeBottomNav(activeOverride: HomeShellTab.home),
    );
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('active rewards shows pill label Reward', (tester) async {
    await tester.pumpApp(
      const HomeBottomNav(activeOverride: HomeShellTab.rewards),
    );
    expect(find.text('Reward'), findsOneWidget);
  });

  testWidgets('active settings shows pill label Settings', (tester) async {
    await tester.pumpApp(
      const HomeBottomNav(activeOverride: HomeShellTab.settings),
    );
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('inactive tabs hide labels from hit testing', (tester) async {
    await tester.pumpApp(
      const HomeBottomNav(activeOverride: HomeShellTab.home),
    );
    expect(find.text('Home').hitTestable(), findsOneWidget);
    expect(find.text('Reward').hitTestable(), findsNothing);
    expect(find.text('Order').hitTestable(), findsNothing);
    expect(find.text('Wallet').hitTestable(), findsNothing);
    expect(find.text('Settings').hitTestable(), findsNothing);
  });

  testWidgets('pill uses thin white border', (tester) async {
    await tester.pumpApp(
      const HomeBottomNav(activeOverride: HomeShellTab.home),
    );
    final pill = find.descendant(
      of: find.byType(HomeBottomNav),
      matching: find.byWidgetPredicate((w) {
        if (w is! Container) return false;
        final decoration = w.decoration;
        if (decoration is! BoxDecoration) return false;
        return decoration.color == AppColors.homeNavActive &&
            decoration.border != null;
      }),
    );
    expect(pill, findsOneWidget);
    final decoration =
        tester.widget<Container>(pill).decoration! as BoxDecoration;
    expect(decoration.border, isA<Border>());
    final border = decoration.border as Border;
    expect(border.top.width, AppDimens.homeNavPillBorderWidth);
    expect(border.top.color, AppColors.onPrimary);
  });

  testWidgets('tap order shows coming soon without selecting order', (
    tester,
  ) async {
    await tester.pumpApp(
      const HomeBottomNav(activeOverride: HomeShellTab.home),
    );
    await tester.tap(find.byIcon(Icons.takeout_dining_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Home').hitTestable(), findsOneWidget);
    expect(find.text('Order').hitTestable(), findsNothing);
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('reduce motion shows active label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: HomeBottomNav(activeOverride: HomeShellTab.rewards),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Reward'), findsOneWidget);
  });
}
