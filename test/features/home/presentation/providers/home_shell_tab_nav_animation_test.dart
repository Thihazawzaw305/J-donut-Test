import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/features/home/presentation/providers/home_shell_tab_provider.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_shell.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('pill transitions when shell tab provider changes', (
    tester,
  ) async {
    await tester.pumpApp(
      const ProviderScope(
        child: HomeBottomNav(),
      ),
    );
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(HomeBottomNav)),
    );
    container.read(homeShellTabProvider.notifier).setTab(HomeShellTab.rewards);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Reward').hitTestable(), findsOneWidget);

    final rewardPill = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const ValueKey('home_nav_rewards')),
        matching: find.byWidgetPredicate((w) {
          if (w is! Container) return false;
          final decoration = w.decoration;
          return decoration is BoxDecoration && decoration.border != null;
        }),
      ),
    );
    final decoration = rewardPill.decoration! as BoxDecoration;
    expect(decoration.color, isNot(Colors.transparent));
    expect(decoration.color, isNotNull);
  });

  testWidgets('bottom nav element is reused when switching to rewards', (
    tester,
  ) async {
    await tester.pumpApp(
      const ProviderScope(
        child: HomeShell(body: SizedBox.expand()),
      ),
    );
    await tester.pump();

    final before = tester.element(find.byType(HomeBottomNav));
    final container = ProviderScope.containerOf(before);
    container.read(homeShellTabProvider.notifier).setTab(HomeShellTab.rewards);
    await tester.pump();

    expect(tester.element(find.byType(HomeBottomNav)), same(before));
  });
}
