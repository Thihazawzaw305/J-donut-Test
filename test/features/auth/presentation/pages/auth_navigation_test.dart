import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/core/router/app_router.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/name_fields.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/otp_boxes.dart';

import '../../../../helpers/catalog_test_overrides.dart';
import '../../../../helpers/pump_jdonuts_app.dart';
import '../../../../helpers/select_birthday.dart';

const _phoneInput = '09254135592';
const _e164 = '+959254135592';
final _birthday = DateTime(2000, 5, 30);

/// OTP keeps a periodic ticker; never [WidgetTester.pumpAndSettle] here.
void main() {
  GoRouter routerOf(WidgetTester tester) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(JDonutsApp)),
    );
    return container.read(appRouterProvider);
  }

  Future<void> pumpZeroLatency(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> pressLabeledButton(WidgetTester tester, String label) async {
    tester
        .widget<PrimaryButton>(find.widgetWithText(PrimaryButton, label))
        .onPressed!();
    await pumpZeroLatency(tester);
  }

  testWidgets(
    'register OTP 123456 then name then DOB 30 May 2000 opens Welcome',
    (tester) async {
      await pumpJDonutsApp(
        tester,
        location: AppRoutes.registerOtp,
        settle: false,
        viewport: const Size(800, 1400),
        overrides: [
          authDraftProvider.overrideWith(_PrefillPhoneDraft.new),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(latency: Duration.zero),
          ),
        ],
      );

      await tester.enterText(find.byType(TextField), '123456');
      await pumpZeroLatency(tester);
      expect(find.text("What's your name?"), findsOneWidget);

      final firstNameField = find
          .descendant(
            of: find.byType(NameFields),
            matching: find.byType(TextField),
          )
          .first;
      await tester.enterText(firstNameField, 'Ada');
      await tester.pump();
      await pressLabeledButton(tester, 'CONTINUE');
      expect(find.text("What's your date of birth?"), findsOneWidget);

      await selectBirthdayInTest(tester, _birthday);
      await pressLabeledButton(tester, 'CONTINUE');
      await tester.pump();
      await tester.pump();
      await tester.pump(AppMotion.medium);
      expect(find.textContaining('Welcome to the'), findsOneWidget);
      expect(routerOf(tester).state.uri.path, AppRoutes.welcome);

      expect(routerOf(tester).canPop(), isFalse);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.textContaining('Welcome to the'), findsOneWidget);
      expect(find.text("What's your date of birth?"), findsNothing);

      await tester.tap(find.text("LET'S EXPLORE"));
      await tester.pump();
      await tester.pump(AppMotion.medium);
      await tester.pump(AppMotion.medium);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Ada'), findsOneWidget);

      await tearDownCatalog(tester);
    },
  );

  testWidgets(
    'login OTP 123456 opens Home and system back does not return to OTP',
    (tester) async {
      await pumpJDonutsApp(
        tester,
        location: AppRoutes.loginOtp,
        settle: false,
        overrides: [
          authDraftProvider.overrideWith(_PrefillPhoneDraft.new),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(
              latency: Duration.zero,
              registeredNumbers: {_e164},
            ),
          ),
        ],
      );

      await tester.enterText(find.byType(TextField), '123456');
      await pumpZeroLatency(tester);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Home'), findsOneWidget);
      expect(routerOf(tester).state.uri.path, AppRoutes.home);
      expect(routerOf(tester).canPop(), isFalse);

      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(OtpDigitBox), findsNothing);
    },
  );
}

class _PrefillPhoneDraft extends AuthDraftNotifier {
  @override
  AuthDraft build() => const AuthDraft(phoneInput: _phoneInput);
}
