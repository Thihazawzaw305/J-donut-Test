import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/otp_boxes.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/pump_jdonuts_app.dart';

const _phoneInput = '09254135592';
const _e164 = '+959254135592';

void main() {
  Future<void> pumpOtp(
    WidgetTester tester, {
    required String location,
    List<Override> extraOverrides = const [],
  }) async {
    await pumpJDonutsApp(
      tester,
      location: location,
      settle: false,
      overrides: [
        authDraftProvider.overrideWith(_PrefillPhoneDraft.new),
        ...extraOverrides,
      ],
    );
  }

  testWidgets(
    'register OTP matches layout: six boxes, E.164, resend, legal, ring, no Continue',
    (tester) async {
      await pumpOtp(tester, location: AppRoutes.registerOtp);

      expect(find.byType(OtpDigitBox), findsNWidgets(6));
      expect(find.text("We've sent 6 digit OTP to $_e164"), findsOneWidget);
      expect(find.text("Didn't receive the code?"), findsOneWidget);
      expect(
        find.text('resend in 5 : 00 min', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('Terms of Use'), findsOneWidget);
      expect(find.byType(StepProgressRing), findsOneWidget);
      expect(find.byType(PrimaryButton), findsNothing);
    },
  );

  testWidgets('login OTP hides the progress ring', (tester) async {
    await pumpOtp(tester, location: AppRoutes.loginOtp);

    expect(find.byType(StepProgressRing), findsNothing);
    expect(find.byType(OtpDigitBox), findsNWidgets(6));
  });

  testWidgets('wrong code clears boxes and shows a message under them', (
    tester,
  ) async {
    await pumpOtp(
      tester,
      location: AppRoutes.registerOtp,
      extraOverrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(latency: Duration.zero),
        ),
      ],
    );

    await tester.enterText(find.byType(TextField), '123457');
    await tester.pump();

    expect(find.text('That code is incorrect.'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);
  });

  testWidgets('correct register code opens the name page', (tester) async {
    await pumpOtp(
      tester,
      location: AppRoutes.registerOtp,
      extraOverrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(latency: Duration.zero),
        ),
      ],
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();

    expect(find.text("What's your name?"), findsOneWidget);
  });

  testWidgets('correct login code opens the home placeholder', (tester) async {
    await pumpOtp(
      tester,
      location: AppRoutes.loginOtp,
      extraOverrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            latency: Duration.zero,
            registeredNumbers: {_e164},
          ),
        ),
      ],
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('login OTP for an unknown number shows a not-registered toast', (
    tester,
  ) async {
    await pumpOtp(
      tester,
      location: AppRoutes.loginOtp,
      extraOverrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(latency: Duration.zero),
        ),
      ],
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();

    expect(find.text("This number isn't registered yet."), findsOneWidget);
  });

  testWidgets('already-registered verify failure shows a toast', (
    tester,
  ) async {
    final repository = ControllableAuthRepository();
    await pumpOtp(
      tester,
      location: AppRoutes.registerOtp,
      extraOverrides: [authRepositoryProvider.overrideWithValue(repository)],
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    repository.completeVerify(const Err(AuthFailure.alreadyRegistered));
    await tester.pump();

    expect(
      find.text('This number is already registered. Please log in.'),
      findsOneWidget,
    );
  });

  testWidgets('six digits send one in-flight verify and ignore extra submits', (
    tester,
  ) async {
    final repository = ControllableAuthRepository();
    await pumpOtp(
      tester,
      location: AppRoutes.registerOtp,
      extraOverrides: [authRepositoryProvider.overrideWithValue(repository)],
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();

    expect(repository.verifyCount, 1);
  });
}

class _PrefillPhoneDraft extends AuthDraftNotifier {
  @override
  AuthDraft build() => const AuthDraft(phoneInput: _phoneInput);
}
