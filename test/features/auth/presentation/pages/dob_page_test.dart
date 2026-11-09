import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/pump_jdonuts_app.dart';

const _phoneInput = '09254135592';
final _fixedNow = DateTime(2026, 11, 9);
final _birthday = DateTime(2000, 5, 30);

void main() {
  PrimaryButton continueButton(WidgetTester tester) => tester
      .widget<PrimaryButton>(find.widgetWithText(PrimaryButton, 'CONTINUE'));

  List<Override> dobOverrides({ControllableAuthRepository? repository}) => [
    authDraftProvider.overrideWith(_PrefillNameDraft.new),
    clockProvider.overrideWithValue(() => _fixedNow),
    if (repository != null)
      authRepositoryProvider.overrideWithValue(repository),
  ];

  Future<void> pumpDob(
    WidgetTester tester, {
    ControllableAuthRepository? repository,
    bool settle = true,
  }) => pumpJDonutsApp(
    tester,
    location: AppRoutes.registerDob,
    settle: settle,
    overrides: dobOverrides(repository: repository),
  );

  Future<void> selectBirthday(WidgetTester tester, DateTime date) async {
    final chrome = tester.getRect(
      find
          .ancestor(of: find.text('Day'), matching: find.byType(Container))
          .first,
    );
    await tester.tapAt(chrome.topLeft + const Offset(8, 8));
    await tester.pumpAndSettle();
    tester
        .widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker))
        .onDateTimeChanged(date);
    await tester.pump();
    await tester.tap(find.text('SELECT'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'date-of-birth step shows three fields, Continue, legal, and a checked ring',
    (tester) async {
      await pumpDob(tester);

      expect(find.text("What's your date of birth?"), findsOneWidget);
      expect(find.text('Day'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
      expect(find.text('Year'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.widgetWithText(PrimaryButton, 'CONTINUE'), findsOneWidget);
      expect(find.textContaining('Terms of Use'), findsOneWidget);

      final ring = tester.widget<StepProgressRing>(
        find.byType(StepProgressRing),
      );
      expect(ring.currentStep, 4);
      expect(ring.showCheck, isTrue);
    },
  );

  testWidgets('Continue stays disabled while the date is empty', (
    tester,
  ) async {
    await pumpDob(tester);

    expect(continueButton(tester).onPressed, isNull);
  });

  testWidgets('tapping the Day field chrome opens the birthday sheet', (
    tester,
  ) async {
    await pumpDob(tester);

    final chrome = tester.getRect(
      find
          .ancestor(of: find.text('Day'), matching: find.byType(Container))
          .first,
    );
    await tester.tapAt(chrome.topLeft + const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(find.text('Select your Birthday'), findsOneWidget);
  });

  testWidgets('selecting 30 May 2000 enables Continue', (tester) async {
    await pumpDob(tester);

    await selectBirthday(tester, _birthday);

    expect(find.text('30'), findsOneWidget);
    expect(find.text('May'), findsOneWidget);
    expect(find.text('2000'), findsOneWidget);
    expect(continueButton(tester).onPressed, isNotNull);
  });

  testWidgets('submit shows Creating overlay then opens Welcome', (
    tester,
  ) async {
    final repository = ControllableAuthRepository();
    await pumpDob(tester, repository: repository);

    await selectBirthday(tester, _birthday);
    await tester.tap(find.widgetWithText(PrimaryButton, 'CONTINUE'));
    await tester.pump();

    expect(find.text('Creating...'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('May'), findsOneWidget);
    expect(find.text('2000'), findsOneWidget);
    expect(
      tester.widgetList<TextField>(find.byType(TextField)),
      everyElement(predicate<TextField>((field) => field.enabled ?? true)),
    );
    expect(find.widgetWithText(PrimaryButton, 'CONTINUE'), findsOneWidget);
    expect(continueButton(tester).isLoading, isFalse);
    expect(repository.completeRegistrationCount, 1);

    repository.finishCompleteRegistration(const Ok(null));
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
  });
}

class _PrefillNameDraft extends AuthDraftNotifier {
  @override
  AuthDraft build() =>
      const AuthDraft(phoneInput: _phoneInput, firstName: 'Ada');
}
