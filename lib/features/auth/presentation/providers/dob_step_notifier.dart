import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../domain/validators/dob_validator.dart';
import '../../domain/validators/phone_validator.dart';
import 'auth_draft_notifier.dart';
import 'auth_providers.dart';
import 'dob_step_state.dart';

class DobStepNotifier extends Notifier<DobStepState> {
  @override
  DobStepState build() {
    final draft = ref.read(authDraftProvider);
    final dob = draft.dateOfBirth;
    final now = ref.read(clockProvider)();
    final validation = validateDateOfBirth(
      year: dob?.year,
      month: dob?.month,
      day: dob?.day,
      now: now,
    );
    return DobStepState(
      year: dob?.year,
      month: dob?.month,
      day: dob?.day,
      validation: validation,
    );
  }

  void onDateChanged({int? year, int? month, int? day}) {
    if (state.isSubmitting) return;
    final nextYear = year ?? state.year;
    final nextMonth = month ?? state.month;
    final nextDay = day ?? state.day;
    final now = ref.read(clockProvider)();
    final validation = validateDateOfBirth(
      year: nextYear,
      month: nextMonth,
      day: nextDay,
      now: now,
    );
    final dob = validation.valueOrNull;
    if (dob != null) {
      ref.read(authDraftProvider.notifier).updateDateOfBirth(dob);
    }
    state = state.copyWith(
      year: nextYear,
      month: nextMonth,
      day: nextDay,
      validation: validation,
      status: const DobSubmitIdle(),
    );
  }

  Future<void> submit() async {
    final dob = state.validation.valueOrNull;
    if (dob == null || state.isSubmitting) return;

    final draft = ref.read(authDraftProvider);
    final phone = validatePhone(draft.phoneInput).valueOrNull;
    if (phone == null) return;

    final firstName = draft.firstName.trim();
    if (firstName.isEmpty) return;

    state = state.copyWith(status: const DobSubmitting());
    final result = await ref.read(completeRegistrationProvider)(
      phone,
      firstName: firstName,
      lastName: draft.lastName.trim().isEmpty
          ? null
          : draft.lastName.trim(),
      dateOfBirth: dob,
    );
    if (!ref.mounted) return;

    state = state.copyWith(
      status: switch (result) {
        Ok() => const DobSubmitSuccess(),
        Err(:final error) => DobSubmitFailure(error),
      },
    );
  }
}

final dobStepProvider =
    NotifierProvider.autoDispose<DobStepNotifier, DobStepState>(
  DobStepNotifier.new,
);
