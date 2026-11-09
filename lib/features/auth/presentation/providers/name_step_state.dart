import '../../../../core/errors/result.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/failures/name_validation_failure.dart';

sealed class NameSubmitStatus {
  const NameSubmitStatus();
}

final class NameSubmitIdle extends NameSubmitStatus {
  const NameSubmitIdle();
}

final class NameSubmitting extends NameSubmitStatus {
  const NameSubmitting();
}

final class NameSubmitSuccess extends NameSubmitStatus {
  const NameSubmitSuccess();
}

final class NameSubmitFailure extends NameSubmitStatus {
  const NameSubmitFailure(this.failure);

  final AuthFailure failure;
}

class NameStepState {
  const NameStepState({
    required this.firstName,
    required this.lastName,
    required this.firstValidation,
    required this.lastValidation,
    this.status = const NameSubmitIdle(),
  });

  final String firstName;
  final String lastName;
  final Result<String, NameValidationFailure> firstValidation;
  final Result<String?, NameValidationFailure> lastValidation;
  final NameSubmitStatus status;

  bool get isSubmitting => status is NameSubmitting;

  bool get canSubmit =>
      firstValidation.isOk && lastValidation.isOk && !isSubmitting;

  NameValidationFailure? get visibleFirstError =>
      firstName.isEmpty ? null : firstValidation.errorOrNull;

  NameValidationFailure? get visibleLastError =>
      lastName.isEmpty ? null : lastValidation.errorOrNull;

  NameStepState copyWith({
    String? firstName,
    String? lastName,
    Result<String, NameValidationFailure>? firstValidation,
    Result<String?, NameValidationFailure>? lastValidation,
    NameSubmitStatus? status,
  }) => NameStepState(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    firstValidation: firstValidation ?? this.firstValidation,
    lastValidation: lastValidation ?? this.lastValidation,
    status: status ?? this.status,
  );
}
