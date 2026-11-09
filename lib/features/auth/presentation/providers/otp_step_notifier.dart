import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/entities/phone_number.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/policies/otp_policy.dart';
import '../../domain/validators/otp_validator.dart';
import '../../domain/validators/phone_validator.dart';
import 'auth_draft_notifier.dart';
import 'auth_providers.dart';
import 'otp_step_state.dart';

final _nonDigits = RegExp(r'\D');

class OtpStepNotifier extends Notifier<OtpStepState> {
  OtpStepNotifier(this.flow);

  final AuthFlow flow;

  @override
  OtpStepState build() {
    final digits = _sanitize(ref.read(authDraftProvider).otpInput);
    return OtpStepState(
      digits: digits,
      resendRemaining: OtpPolicy.resendSeconds,
    );
  }

  void onChanged(String raw) {
    if (state.isSubmitting || state.locked) return;
    final digits = _sanitize(raw);
    ref.read(authDraftProvider.notifier).updateOtpInput(digits);
    state = state.copyWith(
      digits: digits,
      status: const OtpSubmitIdle(),
      clearInlineMessage: !state.locked,
    );
    if (digits.length == OtpPolicy.codeLength && !state.locked) {
      unawaited(submit());
    }
  }

  Future<void> submit() async {
    if (state.locked || state.isSubmitting) return;
    final code = validateOtp(state.digits).valueOrNull;
    final phone = _draftPhone();
    if (code == null || phone == null) return;

    state = state.copyWith(status: const OtpSubmitting());
    final result = await ref.read(verifyOtpProvider)(
      phone,
      code,
      flow: flow,
    );
    if (!ref.mounted) return;
    switch (result) {
      case Ok():
        state = state.copyWith(status: const OtpSubmitSuccess());
      case Err(:final error):
        _applyFailure(error);
    }
  }

  Future<void> resend() async {
    if (state.resendRemaining != 0) return;
    final phone = _draftPhone();
    if (phone == null) return;

    final result = await ref.read(resendOtpProvider)(phone);
    if (!ref.mounted) return;
    switch (result) {
      case Err(:final error):
        state = state.copyWith(status: OtpSubmitFailure(error));
      case Ok():
        state = state.copyWith(
          locked: false,
          resendRemaining: OtpPolicy.resendSeconds,
          status: const OtpSubmitIdle(),
          clearInlineMessage: true,
        );
    }
  }

  void tick() {
    if (state.resendRemaining <= 0) return;
    state = state.copyWith(resendRemaining: state.resendRemaining - 1);
  }

  void _applyFailure(AuthFailure error) {
    final isOtpError =
        error == AuthFailure.wrongOtp || error == AuthFailure.otpLocked;
    if (!isOtpError) {
      state = state.copyWith(status: OtpSubmitFailure(error));
      return;
    }
    ref.read(authDraftProvider.notifier).updateOtpInput('');
    state = state.copyWith(
      digits: '',
      locked: error == AuthFailure.otpLocked || state.locked,
      status: OtpSubmitFailure(error),
      shakeEpoch: state.shakeEpoch + 1,
      inlineMessage: error,
    );
  }

  String _sanitize(String raw) {
    final digits = raw.replaceAll(_nonDigits, '');
    if (digits.length <= OtpPolicy.codeLength) return digits;
    return digits.substring(0, OtpPolicy.codeLength);
  }

  PhoneNumber? _draftPhone() =>
      validatePhone(ref.read(authDraftProvider).phoneInput).valueOrNull;
}

final otpStepProvider = NotifierProvider.autoDispose
    .family<OtpStepNotifier, OtpStepState, AuthFlow>(OtpStepNotifier.new);
