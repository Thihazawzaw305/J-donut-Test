import '../../domain/failures/auth_failure.dart';

sealed class OtpSubmitStatus {
  const OtpSubmitStatus();
}

final class OtpSubmitIdle extends OtpSubmitStatus {
  const OtpSubmitIdle();
}

final class OtpSubmitting extends OtpSubmitStatus {
  const OtpSubmitting();
}

final class OtpSubmitSuccess extends OtpSubmitStatus {
  const OtpSubmitSuccess();
}

final class OtpSubmitFailure extends OtpSubmitStatus {
  const OtpSubmitFailure(this.failure);

  final AuthFailure failure;
}

class OtpStepState {
  const OtpStepState({
    this.digits = '',
    this.locked = false,
    required this.resendRemaining,
    this.status = const OtpSubmitIdle(),
    this.shakeEpoch = 0,
    this.inlineMessage,
  });

  final String digits;
  final bool locked;
  final int resendRemaining;
  final OtpSubmitStatus status;
  final int shakeEpoch;
  final AuthFailure? inlineMessage;

  bool get isSubmitting => status is OtpSubmitting;

  OtpStepState copyWith({
    String? digits,
    bool? locked,
    int? resendRemaining,
    OtpSubmitStatus? status,
    int? shakeEpoch,
    AuthFailure? inlineMessage,
    bool clearInlineMessage = false,
  }) => OtpStepState(
    digits: digits ?? this.digits,
    locked: locked ?? this.locked,
    resendRemaining: resendRemaining ?? this.resendRemaining,
    status: status ?? this.status,
    shakeEpoch: shakeEpoch ?? this.shakeEpoch,
    inlineMessage: clearInlineMessage
        ? null
        : inlineMessage ?? this.inlineMessage,
  );
}
