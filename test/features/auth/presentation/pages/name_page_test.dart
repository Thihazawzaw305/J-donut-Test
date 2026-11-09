import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/core/router/app_router.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/pump_jdonuts_app.dart';

const _phoneInput = '09254135592';

void main() {
  PrimaryButton continueButton(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton));

  Finder firstField() => find.byType(TextField).at(0);
  Finder lastField() => find.byType(TextField).at(1);

  Future<void> pumpName(WidgetTester tester) => pumpJDonutsApp(
    tester,
    location: AppRoutes.registerName,
    overrides: [authDraftProvider.overrideWith(_PrefillPhoneDraft.new)],
  );

  testWidgets('name step shows two fields, Continue, legal, and ring step 3', (
    tester,
  ) async {
    await pumpName(tester);

    expect(find.text("What's your name?"), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(find.textContaining('Terms of Use'), findsOneWidget);
    expect(find.byType(StepProgressRing), findsOneWidget);
    expect(find.bySemanticsLabel('Step 3 of 4'), findsOneWidget);
  });

  testWidgets(
    'Continue stays disabled until first is valid and last is empty or valid',
    (tester) async {
      await pumpName(tester);
      expect(continueButton(tester).onPressed, isNull);

      await tester.enterText(firstField(), 'Ada');
      await tester.pump();
      expect(continueButton(tester).onPressed, isNotNull);

      await tester.enterText(lastField(), 'Lee2');
      await tester.pump();
      expect(continueButton(tester).onPressed, isNull);

      await tester.enterText(lastField(), '');
      await tester.pump();
      expect(continueButton(tester).onPressed, isNotNull);

      await tester.enterText(lastField(), 'Lee');
      await tester.pump();
      expect(continueButton(tester).onPressed, isNotNull);
    },
  );

  testWidgets('a digit in first name shows an inline error', (tester) async {
    await pumpName(tester);

    await tester.enterText(firstField(), 'Ada2');
    await tester.pump();

    expect(find.text("Names can't include numbers."), findsOneWidget);
    expect(continueButton(tester).onPressed, isNull);
  });

  testWidgets('submit shows a spinner then opens the date of birth page', (
    tester,
  ) async {
    final repository = ControllableAuthRepository();
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.registerName,
      overrides: [
        authDraftProvider.overrideWith(_PrefillPhoneDraft.new),
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );

    await tester.enterText(firstField(), 'Ada');
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repository.saveProfileNameCount, 1);

    repository.completeSaveProfileName(const Ok(null));
    await tester.pump();

    expect(find.text("What's your date of birth?"), findsOneWidget);
  });

  testWidgets('back keeps the typed names via the draft', (tester) async {
    await pumpName(tester);

    await tester.enterText(firstField(), 'Ada');
    await tester.enterText(lastField(), 'Lee');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(JDonutsApp)),
    );
    container.read(appRouterProvider).go(AppRoutes.registerName);
    await tester.pumpAndSettle();

    expect(find.text('Ada'), findsOneWidget);
    expect(find.text('Lee'), findsOneWidget);
  });
}

class _PrefillPhoneDraft extends AuthDraftNotifier {
  @override
  AuthDraft build() => const AuthDraft(phoneInput: _phoneInput);
}
