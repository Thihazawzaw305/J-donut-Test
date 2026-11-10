import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/date_of_birth.dart';
import 'package:j_donuts_app/features/auth/domain/entities/otp_code.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/policies/otp_policy.dart';

import '../../../../helpers/in_memory_registered_phones_store.dart';

void main() {
  const known = PhoneNumber('9254135592');
  const unknown = PhoneNumber('912345678');

  FakeAuthRepository build() => FakeAuthRepository(
    latency: Duration.zero,
    registeredNumbers: {known.e164},
  );

  test('registering a new number succeeds', () async {
    final result = await build().requestOtp(unknown, flow: AuthFlow.register);
    expect(result.isOk, isTrue);
  });

  test('registering an existing number fails as already registered', () async {
    final result = await build().requestOtp(known, flow: AuthFlow.register);
    expect(result.errorOrNull, AuthFailure.alreadyRegistered);
  });

  test('logging in with an unknown number fails as not registered', () async {
    final result = await build().requestOtp(unknown, flow: AuthFlow.login);
    expect(result.errorOrNull, AuthFailure.notRegistered);
  });

  test('logging in with a registered number succeeds', () async {
    final result = await build().requestOtp(known, flow: AuthFlow.login);
    expect(result.isOk, isTrue);
  });

  test('defaults to a one second fake latency', () {
    expect(FakeAuthRepository.defaultLatency, const Duration(seconds: 1));
  });

  group('verifyOtp', () {
    test('returns wrongOtp for an incorrect code', () async {
      final repo = build();
      final result = await repo.verifyOtp(
        unknown,
        const OtpCode('000000'),
        flow: AuthFlow.register,
      );
      expect(result.errorOrNull, AuthFailure.wrongOtp);
    });

    test('locks after three wrong attempts', () async {
      final repo = build();
      const wrong = OtpCode('000000');

      expect(
        (await repo.verifyOtp(unknown, wrong, flow: AuthFlow.register))
            .errorOrNull,
        AuthFailure.wrongOtp,
      );
      expect(
        (await repo.verifyOtp(unknown, wrong, flow: AuthFlow.register))
            .errorOrNull,
        AuthFailure.wrongOtp,
      );
      expect(
        (await repo.verifyOtp(unknown, wrong, flow: AuthFlow.register))
            .errorOrNull,
        AuthFailure.otpLocked,
      );
    });

    test('rejects the correct code while locked until resend', () async {
      final repo = build();
      const wrong = OtpCode('000000');
      const correct = OtpCode(OtpPolicy.correctCode);

      for (var i = 0; i < OtpPolicy.maxAttempts; i++) {
        await repo.verifyOtp(unknown, wrong, flow: AuthFlow.register);
      }

      expect(
        (await repo.verifyOtp(unknown, correct, flow: AuthFlow.register))
            .errorOrNull,
        AuthFailure.otpLocked,
      );

      await repo.resendOtp(unknown);

      expect(
        (await repo.verifyOtp(unknown, correct, flow: AuthFlow.register)).isOk,
        isTrue,
      );
    });

    test('resend resets attempts so verification can continue', () async {
      final repo = build();
      const wrong = OtpCode('000000');

      for (var i = 0; i < OtpPolicy.maxAttempts; i++) {
        await repo.verifyOtp(unknown, wrong, flow: AuthFlow.register);
      }
      expect(
        (await repo.verifyOtp(unknown, wrong, flow: AuthFlow.register))
            .errorOrNull,
        AuthFailure.otpLocked,
      );

      await repo.resendOtp(unknown);

      expect(
        (await repo.verifyOtp(unknown, wrong, flow: AuthFlow.register))
            .errorOrNull,
        AuthFailure.wrongOtp,
      );
    });

    test('accepts the correct fake code', () async {
      final repo = build();
      final result = await repo.verifyOtp(
        unknown,
        const OtpCode(OtpPolicy.correctCode),
        flow: AuthFlow.register,
      );
      expect(result.isOk, isTrue);
    });

    test('login with an unknown number fails as not registered', () async {
      final repo = build();
      final result = await repo.verifyOtp(
        unknown,
        const OtpCode(OtpPolicy.correctCode),
        flow: AuthFlow.login,
      );
      expect(result.errorOrNull, AuthFailure.notRegistered);
    });
  });

  test('completeRegistration registers the number for later login', () async {
    final repo = FakeAuthRepository(latency: Duration.zero);
    const phone = unknown;

    await repo.completeRegistration(
      phone,
      firstName: 'Aye',
      dateOfBirth: const DateOfBirth(year: 2000, month: 1, day: 1),
    );

    expect(
      (await repo.requestOtp(phone, flow: AuthFlow.login)).isOk,
      isTrue,
    );
  });

  test('completeRegistration persists across repository instances', () async {
    const phone = unknown;
    final store = InMemoryRegisteredPhonesStore();

    await FakeAuthRepository(latency: Duration.zero, store: store)
        .completeRegistration(
      phone,
      firstName: 'Aye',
      dateOfBirth: const DateOfBirth(year: 2000, month: 1, day: 1),
    );

    final relogin = FakeAuthRepository(latency: Duration.zero, store: store);
    expect((await relogin.requestOtp(phone, flow: AuthFlow.login)).isOk, isTrue);
  });
}
