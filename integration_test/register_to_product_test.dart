import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/session_providers.dart';

import '../test/helpers/in_memory_session_storage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('register phone through welcome to product placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(InMemorySessionStorage()),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(latency: Duration.zero),
          ),
        ],
        child: const JDonutsApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '09254135592');
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Ada');
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text("LET'S EXPLORE"));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text('Coconut Donut'));
    await tester.pumpAndSettle();

    expect(find.text('3,200 Ks'), findsOneWidget);
  });
}
