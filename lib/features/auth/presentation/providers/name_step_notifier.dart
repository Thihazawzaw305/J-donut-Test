import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../domain/validators/name_validator.dart';
import '../../domain/validators/phone_validator.dart';
import 'auth_draft_notifier.dart';
import 'auth_providers.dart';
import 'name_step_state.dart';

class NameStepNotifier extends Notifier<NameStepState> {
  @override
  NameStepState build() {
    final draft = ref.read(authDraftProvider);
    final firstValidation = validateFirstName(draft.firstName);
    final lastValidation = validateLastName(draft.lastName);
    return NameStepState(
      firstName: draft.firstName,
      lastName: draft.lastName,
      firstValidation: firstValidation,
      lastValidation: lastValidation,
    );
  }

  void onFirstNameChanged(String value) {
    if (state.isSubmitting) return;
    ref.read(authDraftProvider.notifier).updateFirstName(value);
    state = state.copyWith(
      firstName: value,
      firstValidation: validateFirstName(value),
      status: const NameSubmitIdle(),
    );
  }

  void onLastNameChanged(String value) {
    if (state.isSubmitting) return;
    ref.read(authDraftProvider.notifier).updateLastName(value);
    state = state.copyWith(
      lastName: value,
      lastValidation: validateLastName(value),
      status: const NameSubmitIdle(),
    );
  }

  Future<void> submit() async {
    if (!state.canSubmit || state.isSubmitting) return;
    final phone = validatePhone(ref.read(authDraftProvider).phoneInput).valueOrNull;
    if (phone == null) return;

    final firstName = state.firstValidation.valueOrNull;
    if (firstName == null) return;

    state = state.copyWith(status: const NameSubmitting());
    final result = await ref.read(saveProfileNameProvider)(
      phone,
      firstName: firstName,
      lastName: state.lastValidation.valueOrNull,
    );
    if (!ref.mounted) return;

    state = state.copyWith(
      status: switch (result) {
        Ok() => const NameSubmitSuccess(),
        Err(:final error) => NameSubmitFailure(error),
      },
    );
  }
}

final nameStepProvider =
    NotifierProvider.autoDispose<NameStepNotifier, NameStepState>(
  NameStepNotifier.new,
);
