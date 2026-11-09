import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/name_validation_failure.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/name_step_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/name_step_state.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  const validPhone = '09254135592';
  late ControllableAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = ControllableAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(nameStepProvider, (_, _) {});
    container.read(authDraftProvider.notifier).updatePhoneInput(validPhone);
  });

  NameStepState state() => container.read(nameStepProvider);
  NameStepNotifier notifier() => container.read(nameStepProvider.notifier);

  test('invalid first name blocks submit', () async {
    notifier().onFirstNameChanged('John2');
    notifier().onLastNameChanged('Smith');

    expect(state().canSubmit, isFalse);

    await notifier().submit();
    expect(repository.saveProfileNameCount, 0);
  });

  test('empty last name is allowed', () async {
    notifier().onFirstNameChanged('Alice');
    notifier().onLastNameChanged('');

    expect(state().canSubmit, isTrue);
    expect(state().visibleLastError, isNull);

    final pending = notifier().submit();
    expect(state().isSubmitting, isTrue);

    repository.completeSaveProfileName(const Ok(null));
    await pending;

    expect(state().status, isA<NameSubmitSuccess>());
    expect(repository.saveProfileNameCount, 1);
  });

  test('restores names from the shared draft', () {
    final fresh = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    fresh.read(authDraftProvider.notifier).updateFirstName('Bob');
    fresh.read(authDraftProvider.notifier).updateLastName('Lee');

    expect(fresh.read(nameStepProvider).firstName, 'Bob');
    expect(fresh.read(nameStepProvider).lastName, 'Lee');
    expect(fresh.read(nameStepProvider).canSubmit, isTrue);
  });

  test('submit shows failure from the repository', () async {
    notifier().onFirstNameChanged('Alice');
    final pending = notifier().submit();
    repository.completeSaveProfileName(const Err(AuthFailure.notRegistered));
    await pending;

    expect(state().status, isA<NameSubmitFailure>());
  });

  test('a second submit while submitting sends no extra request', () async {
    notifier().onFirstNameChanged('Alice');
    final first = notifier().submit();
    final second = notifier().submit();
    repository.completeSaveProfileName(const Ok(null));
    await Future.wait([first, second]);

    expect(repository.saveProfileNameCount, 1);
  });

  test('exposes first name error only for non-empty invalid input', () {
    notifier().onFirstNameChanged('John2');
    expect(state().visibleFirstError, NameValidationFailure.containsDigit);

    notifier().onFirstNameChanged('');
    expect(state().visibleFirstError, isNull);
  });
}
