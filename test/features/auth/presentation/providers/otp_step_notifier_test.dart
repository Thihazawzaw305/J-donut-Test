import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/otp_code.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/policies/otp_policy.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/otp_step_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/otp_step_state.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  const validPhone = '09254135592';
  final provider = otpStepProvider(AuthFlow.register);
  late ControllableAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = ControllableAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(provider, (_, _) {});
    container.read(authDraftProvider.notifier).updatePhoneInput(validPhone);
  });

  OtpStepState state() => container.read(provider);
  OtpStepNotifier notifier() => container.read(provider.notifier);

  test('restores digits from the shared draft', () {
    final fresh = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    fresh.read(authDraftProvider.notifier).updateOtpInput('123');

    expect(fresh.read(provider).digits, '123');
    expect(fresh.read(provider).resendRemaining, OtpPolicy.resendSeconds);
  });

  test('auto-submits when six digits are entered', () async {
    notifier().onChanged('123456');

    expect(state().isSubmitting, isTrue);
    expect(repository.verifyCount, 1);
    expect(repository.lastCode, const OtpCode('123456'));
    expect(container.read(authDraftProvider).otpInput, '123456');

    repository.completeVerify(const Ok(null));
    await pumpEventQueue();

    expect(state().status, isA<OtpSubmitSuccess>());
  });

  test('a second submit while submitting sends no extra request', () async {
    notifier().onChanged('123456');
    final second = notifier().submit();
    repository.completeVerify(const Ok(null));
    await second;

    expect(repository.verifyCount, 1);
  });

  test('three wrong codes lock and ignore further submit', () async {
    await _enterAndComplete(
      notifier,
      repository,
      const Err(AuthFailure.wrongOtp),
    );
    expect(state().digits, isEmpty);
    expect(state().shakeEpoch, 1);
    expect(state().inlineMessage, AuthFailure.wrongOtp);

    await _enterAndComplete(
      notifier,
      repository,
      const Err(AuthFailure.wrongOtp),
    );
    await _enterAndComplete(
      notifier,
      repository,
      const Err(AuthFailure.otpLocked),
    );

    expect(state().locked, isTrue);
    expect(state().inlineMessage, AuthFailure.otpLocked);
    expect(repository.verifyCount, 3);

    notifier().onChanged('123456');
    await notifier().submit();

    expect(repository.verifyCount, 3);
  });

  test('tick to zero then resend unlocks', () async {
    await _enterAndComplete(
      notifier,
      repository,
      const Err(AuthFailure.otpLocked),
    );
    expect(state().locked, isTrue);

    for (var i = 0; i < OtpPolicy.resendSeconds; i++) {
      notifier().tick();
    }
    expect(state().resendRemaining, 0);

    await notifier().resend();

    expect(repository.resendCount, 1);
    expect(state().locked, isFalse);
    expect(state().resendRemaining, OtpPolicy.resendSeconds);
    expect(state().inlineMessage, isNull);
  });
}

Future<void> _enterAndComplete(
  OtpStepNotifier Function() notifier,
  ControllableAuthRepository repository,
  Result<void, AuthFailure> result,
) async {
  notifier().onChanged('111111');
  repository.completeVerify(result);
  await pumpEventQueue();
}
