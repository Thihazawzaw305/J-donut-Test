import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/features/home/presentation/pages/settings_page.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_shell.dart';

import '../../../../helpers/in_memory_session_storage.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/pump_jdonuts_app.dart';

void main() {
  testWidgets('settings page shows shell with settings tab active', (
    tester,
  ) async {
    await tester.pumpApp(
      const ProviderScope(
        child: HomeShell(
          activeTabOverride: HomeShellTab.settings,
          body: SettingsPage(),
        ),
      ),
    );

    expect(find.byType(HomeBottomNav), findsOneWidget);
    expect(find.text('Settings'), findsNWidgets(2));
  });

  testWidgets('log out clears session and returns to onboarding', (
    tester,
  ) async {
    final storage = InMemorySessionStorage();
    await storage.write('+959254135592');

    await pumpJDonutsApp(
      tester,
      location: AppRoutes.settings,
      sessionStorage: storage,
    );
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text('Log out').evaluate().isNotEmpty) break;
    }

    await tester.tap(find.text('Log out'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2500));

    expect(find.text("LET'S GET STARTED"), findsOneWidget);
    expect(await storage.read(), isNull);
  });
}
