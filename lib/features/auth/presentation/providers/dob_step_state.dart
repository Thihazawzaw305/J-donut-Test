import '../../../../core/errors/result.dart';
import '../../domain/entities/date_of_birth.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/failures/dob_validation_failure.dart';

sealed class DobSubmitStatus {
  const DobSubmitStatus();
}

final class DobSubmitIdle extends DobSubmitStatus {
  const DobSubmitIdle();
}

final class DobSubmitting extends DobSubmitStatus {
  const DobSubmitting();
}

final class DobSubmitSuccess extends DobSubmitStatus {
  const DobSubmitSuccess();
}

final class DobSubmitFailure extends DobSubmitStatus {
  const DobSubmitFailure(this.failure);

  final AuthFailure failure;
}

class DobStepState {
  const DobStepState({
    required this.year,
    required this.month,
    required this.day,
    required this.validation,
    this.status = const DobSubmitIdle(),
  });

  final int? year;
  final int? month;
  final int? day;
  final Result<DateOfBirth, DobValidationFailure> validation;
  final DobSubmitStatus status;

  bool get isSubmitting => status is DobSubmitting;

  bool get canSubmit => validation.isOk && !isSubmitting;

  DobValidationFailure? get visibleError => validation.errorOrNull;

  DobStepState copyWith({
    int? year,
    int? month,
    int? day,
    Result<DateOfBirth, DobValidationFailure>? validation,
    DobSubmitStatus? status,
    bool clearYear = false,
    bool clearMonth = false,
    bool clearDay = false,
  }) => DobStepState(
    year: clearYear ? null : year ?? this.year,
    month: clearMonth ? null : month ?? this.month,
    day: clearDay ? null : day ?? this.day,
    validation: validation ?? this.validation,
    status: status ?? this.status,
  );
}
