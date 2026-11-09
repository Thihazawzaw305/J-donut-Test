import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/phone_validation_failure.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/phone_step_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/phone_step_state.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  const validInput = '09254135592';
  final provider = phoneStepProvider(AuthFlow.register);
  late ControllableAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = ControllableAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(provider, (_, _) {});
  });

  PhoneStepState state() => container.read(provider);
  PhoneStepNotifier notifier() => container.read(provider.notifier);

  test('starts empty and cannot submit', () {
    expect(state().input, isEmpty);
    expect(state().canSubmit, isFalse);
    expect(state().visibleError, isNull);
  });

  test('restores input from the shared draft', () {
    final fresh = ProviderContainer.test();
    fresh.read(authDraftProvider.notifier).updatePhoneInput(validInput);

    expect(fresh.read(provider).input, validInput);
    expect(fresh.read(provider).canSubmit, isTrue);
  });

  test('input change revalidates and saves the draft', () {
    notifier().onInputChanged(validInput);

    expect(state().canSubmit, isTrue);
    expect(container.read(authDraftProvider).phoneInput, validInput);
  });

  test('exposes a format error only for non-empty invalid input', () {
    notifier().onInputChanged('0912');
    expect(state().visibleError, PhoneValidationFailure.invalidFormat);

    notifier().onInputChanged('');
    expect(state().visibleError, isNull);
  });

  test('submit is ignored while the number is invalid', () async {
    notifier().onInputChanged('0912');
    await notifier().submit();

    expect(repository.requestCount, 0);
  });

  test('submit shows submitting then success with the phone number', () async {
    notifier().onInputChanged(validInput);
    final pending = notifier().submit();

    expect(state().isSubmitting, isTrue);
    expect(state().canSubmit, isFalse);

    repository.complete(const Ok(null));
    await pending;

    final status = state().status;
    expect(status, isA<PhoneSubmitSuccess>());
    expect((status as PhoneSubmitSuccess).phone, const PhoneNumber('9254135592'));
  });

  test('a second submit while submitting sends no extra request', () async {
    notifier().onInputChanged(validInput);
    final first = notifier().submit();
    final second = notifier().submit();
    repository.complete(const Ok(null));
    await Future.wait([first, second]);

    expect(repository.requestCount, 1);
  });

  test('submit failure exposes the auth failure', () async {
    notifier().onInputChanged(validInput);
    final pending = notifier().submit();
    repository.complete(const Err(AuthFailure.alreadyRegistered));
    await pending;

    final status = state().status;
    expect(status, isA<PhoneSubmitFailure>());
    expect((status as PhoneSubmitFailure).failure, AuthFailure.alreadyRegistered);
  });
}
