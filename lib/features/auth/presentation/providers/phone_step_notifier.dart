import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/validators/phone_validator.dart';
import 'auth_draft_notifier.dart';
import 'auth_providers.dart';
import 'phone_step_state.dart';

class PhoneStepNotifier extends Notifier<PhoneStepState> {
  PhoneStepNotifier(this.flow);

  final AuthFlow flow;

  @override
  PhoneStepState build() {
    final input = ref.read(authDraftProvider).phoneInput;
    return PhoneStepState(input: input, validation: validatePhone(input));
  }

  void onInputChanged(String input) {
    ref.read(authDraftProvider.notifier).updatePhoneInput(input);
    state = state.copyWith(
      input: input,
      validation: validatePhone(input),
      status: const PhoneSubmitIdle(),
    );
  }

  Future<void> submit() async {
    final phone = state.validation.valueOrNull;
    if (phone == null || state.isSubmitting) return;

    state = state.copyWith(status: const PhoneSubmitting());
    final result = await ref.read(requestOtpProvider)(phone, flow: flow);
    if (!ref.mounted) return;

    state = state.copyWith(
      status: switch (result) {
        Ok() => PhoneSubmitSuccess(phone),
        Err(:final error) => PhoneSubmitFailure(error),
      },
    );
  }
}

final phoneStepProvider = NotifierProvider.autoDispose
    .family<PhoneStepNotifier, PhoneStepState, AuthFlow>(PhoneStepNotifier.new);
