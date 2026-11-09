import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/date_of_birth.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/dob_validation_failure.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/dob_step_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/dob_step_state.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  const validPhone = '09254135592';
  final fixedNow = DateTime(2026, 11, 9);
  late ControllableAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = ControllableAuthRepository();
    container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => fixedNow),
      ],
    );
    container.listen(dobStepProvider, (_, _) {});
    container.read(authDraftProvider.notifier).updatePhoneInput(validPhone);
    container.read(authDraftProvider.notifier).updateFirstName('Alice');
  });

  DobStepState state() => container.read(dobStepProvider);
  DobStepNotifier notifier() => container.read(dobStepProvider.notifier);

  test('31 April cannot submit', () async {
    notifier().onDateChanged(year: 2000, month: 4, day: 31);

    expect(state().canSubmit, isFalse);
    expect(state().validation.errorOrNull, DobValidationFailure.invalidDate);

    await notifier().submit();
    expect(repository.completeRegistrationCount, 0);
  });

  test('valid date of birth submits successfully', () async {
    notifier().onDateChanged(year: 2000, month: 5, day: 15);

    expect(state().canSubmit, isTrue);

    final pending = notifier().submit();
    expect(state().isSubmitting, isTrue);

    repository.finishCompleteRegistration(const Ok(null));
    await pending;

    expect(state().status, isA<DobSubmitSuccess>());
    expect(repository.completeRegistrationCount, 1);
    expect(
      container.read(authDraftProvider).dateOfBirth,
      const DateOfBirth(year: 2000, month: 5, day: 15),
    );
  });

  test('restores date from the shared draft', () {
    final fresh = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => fixedNow),
      ],
    );
    fresh
        .read(authDraftProvider.notifier)
        .updateDateOfBirth(const DateOfBirth(year: 1999, month: 3, day: 1));

    expect(fresh.read(dobStepProvider).year, 1999);
    expect(fresh.read(dobStepProvider).month, 3);
    expect(fresh.read(dobStepProvider).day, 1);
    expect(fresh.read(dobStepProvider).canSubmit, isTrue);
  });

  test('submit shows failure from the repository', () async {
    notifier().onDateChanged(year: 2000, month: 5, day: 15);
    final pending = notifier().submit();
    repository.finishCompleteRegistration(const Err(AuthFailure.notRegistered));
    await pending;

    expect(state().status, isA<DobSubmitFailure>());
  });

  test('a second submit while submitting sends no extra request', () async {
    notifier().onDateChanged(year: 2000, month: 5, day: 15);
    final first = notifier().submit();
    final second = notifier().submit();
    repository.finishCompleteRegistration(const Ok(null));
    await Future.wait([first, second]);

    expect(repository.completeRegistrationCount, 1);
  });
}
