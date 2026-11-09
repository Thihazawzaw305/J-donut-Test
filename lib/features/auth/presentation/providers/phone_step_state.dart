import '../../../../core/errors/result.dart';
import '../../domain/entities/phone_number.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/failures/phone_validation_failure.dart';

sealed class PhoneSubmitStatus {
  const PhoneSubmitStatus();
}

final class PhoneSubmitIdle extends PhoneSubmitStatus {
  const PhoneSubmitIdle();
}

final class PhoneSubmitting extends PhoneSubmitStatus {
  const PhoneSubmitting();
}

final class PhoneSubmitSuccess extends PhoneSubmitStatus {
  const PhoneSubmitSuccess(this.phone);

  final PhoneNumber phone;
}

final class PhoneSubmitFailure extends PhoneSubmitStatus {
  const PhoneSubmitFailure(this.failure);

  final AuthFailure failure;
}

class PhoneStepState {
  const PhoneStepState({
    required this.input,
    required this.validation,
    this.status = const PhoneSubmitIdle(),
  });

  final String input;
  final Result<PhoneNumber, PhoneValidationFailure> validation;
  final PhoneSubmitStatus status;

  bool get isSubmitting => status is PhoneSubmitting;

  bool get canSubmit => validation.isOk && !isSubmitting;

  /// Error worth telling the user about; nothing while the field is untouched.
  PhoneValidationFailure? get visibleError =>
      input.isEmpty ? null : validation.errorOrNull;

  PhoneStepState copyWith({
    String? input,
    Result<PhoneNumber, PhoneValidationFailure>? validation,
    PhoneSubmitStatus? status,
  }) => PhoneStepState(
    input: input ?? this.input,
    validation: validation ?? this.validation,
    status: status ?? this.status,
  );
}
