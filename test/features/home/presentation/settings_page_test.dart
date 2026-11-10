import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import '../../../helpers/in_memory_session_storage.dart';
import '../../../helpers/pump_jdonuts_app.dart';

void main() {
  testWidgets('log out clears session and returns to onboarding', (tester) async {
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
