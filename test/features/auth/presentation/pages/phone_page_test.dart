import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/pump_jdonuts_app.dart';

void main() {
  const validNumber = '09254135592';
  const invalidMessage =
      'Enter a valid Myanmar mobile number, like 09 123 456 789.';

  PrimaryButton continueButton(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton));

  Future<void> typeNumber(WidgetTester tester, String number) async {
    await tester.enterText(find.byType(TextField), number);
    await tester.pump();
  }

  Future<void> tapOutsideField(WidgetTester tester) async {
    await tester.tap(find.text('Enter your phone number'));
    await tester.pumpAndSettle();
  }

  testWidgets('Continue stays disabled until the number is valid', (
    tester,
  ) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    expect(continueButton(tester).onPressed, isNull);

    await typeNumber(tester, '0912');
    expect(continueButton(tester).onPressed, isNull);

    await typeNumber(tester, validNumber);
    expect(continueButton(tester).onPressed, isNotNull);
  });

  testWidgets('done on the keyboard shows one validation toast', (
    tester,
  ) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    await tester.tap(find.byType(TextField));
    await typeNumber(tester, '0912');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text(invalidMessage), findsOneWidget);
  });

  testWidgets('shows a toast when an invalid number loses focus', (
    tester,
  ) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    await tester.tap(find.byType(TextField));
    await typeNumber(tester, '0912');

    await tapOutsideField(tester);

    expect(find.text(invalidMessage), findsOneWidget);
  });

  testWidgets('shows no toast when a valid number loses focus', (tester) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    await tester.tap(find.byType(TextField));
    await typeNumber(tester, validNumber);

    await tapOutsideField(tester);

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('double tap sends one request, shows spinner, then opens OTP', (
    tester,
  ) async {
    final repository = ControllableAuthRepository();
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.registerPhone,
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    await typeNumber(tester, validNumber);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton), warnIfMissed: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repository.requestCount, 1);

    repository.complete(const Ok(null));
    await tester.pumpAndSettle();
    expect(find.text('Verify your number'), findsOneWidget);
  });

  testWidgets('login with an unregistered number offers to register', (
    tester,
  ) async {
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.loginPhone,
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(latency: Duration.zero),
        ),
      ],
    );
    await typeNumber(tester, validNumber);
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(find.text("This number isn't registered yet."), findsOneWidget);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.byType(StepProgressRing), findsOneWidget);
    expect(find.text(validNumber), findsOneWidget);
  });

  testWidgets('progress ring shows on registration and not on login', (
    tester,
  ) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    expect(find.byType(StepProgressRing), findsOneWidget);

    await pumpJDonutsApp(tester, location: AppRoutes.loginPhone);
    expect(find.byType(StepProgressRing), findsNothing);
  });

  testWidgets('back returns to onboarding and keeps the typed number', (
    tester,
  ) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    await typeNumber(tester, validNumber);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    expect(find.text(validNumber), findsOneWidget);
  });

  testWidgets('a stale failure toast is gone after a later successful submit', (
    tester,
  ) async {
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.registerPhone,
      overrides: [
        authRepositoryProvider.overrideWithValue(_FailThenSucceedRepository()),
      ],
    );
    await typeNumber(tester, validNumber);
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Verify your number'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('fits a narrow screen with large text', (tester) async {
    const viewport = Size(320, 568);
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.registerPhone,
      viewport: viewport,
      textScale: 1.3,
    );

    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FailThenSucceedRepository implements AuthRepository {
  var _calls = 0;

  @override
  Future<Result<void, AuthFailure>> requestOtp(
    PhoneNumber phone, {
    required AuthFlow flow,
  }) async =>
      _calls++ == 0 ? const Err(AuthFailure.alreadyRegistered) : const Ok(null);
}
