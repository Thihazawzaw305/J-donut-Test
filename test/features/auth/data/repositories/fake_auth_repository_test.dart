import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';

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
}
