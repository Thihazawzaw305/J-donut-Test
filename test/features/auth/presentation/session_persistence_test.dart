import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/core/router/app_router.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import '../../../helpers/catalog_test_overrides.dart';
import '../../../helpers/in_memory_session_storage.dart';
import '../../../helpers/pump_jdonuts_app.dart';

void main() {
  testWidgets('saved login session opens Home on cold start', (tester) async {
    const e164 = '+959254135592';
    final storage = InMemorySessionStorage();
    final overrides = [
      authDraftProvider.overrideWith(_PrefillPhoneDraft.new),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(latency: Duration.zero, registeredNumbers: {e164}),
      ),
    ];

    await pumpJDonutsApp(
      tester,
      location: AppRoutes.loginOtp,
      settle: false,
      sessionStorage: storage,
      overrides: overrides,
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Home'), findsOneWidget);

    expect(await storage.read(), e164);

    await tester.pumpWidget(const SizedBox.shrink());
    await pumpJDonutsApp(
      tester,
      settle: false,
      sessionStorage: storage,
      overrides: overrides,
    );
    var path = '';
    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      path = ProviderScope.containerOf(
        tester.element(find.byType(JDonutsApp)),
      ).read(appRouterProvider).state.uri.path;
      if (path == AppRoutes.home) break;
    }

    expect(path, AppRoutes.home);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Thiha Zaw Zaw'), findsOneWidget);
    await tearDownCatalog(tester);
  });
}

class _PrefillPhoneDraft extends AuthDraftNotifier {
  @override
  AuthDraft build() => const AuthDraft(phoneInput: '09254135592');
}
