import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/home/presentation/pages/settings_page.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_shell.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('settings page shows shell with settings tab active', (
    tester,
  ) async {
    await tester.pumpApp(
      const ProviderScope(
        child: HomeShell(
          activeTab: HomeShellTab.settings,
          body: SettingsPage(),
        ),
      ),
    );

    expect(find.byType(HomeBottomNav), findsOneWidget);
    expect(find.text('Settings'), findsNWidgets(2));
  });
}
