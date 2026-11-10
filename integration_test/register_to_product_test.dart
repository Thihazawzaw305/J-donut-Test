import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/session_providers.dart';

import '../test/helpers/in_memory_session_storage.dart';
import '../test/helpers/select_birthday.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final birthday = DateTime(2000, 5, 30);

  testWidgets('register through welcome opens coconut product detail', (
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

    await selectBirthdayInTest(tester, birthday);
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text("LET'S EXPLORE"));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final coconut = find.text('Coconut Donut').first;
    await tester.scrollUntilVisible(
      coconut,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(coconut);
    await tester.tap(coconut);
    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(find.text('JD022123'), findsOneWidget);
    expect(find.text('3,200 MMK'), findsWidgets);
  });
}
