import '../../../../core/errors/result.dart';
import '../entities/date_of_birth.dart';
import '../failures/dob_validation_failure.dart';
import '../policies/age_policy.dart';

Result<DateOfBirth, DobValidationFailure> validateDateOfBirth({
  int? year,
  int? month,
  int? day,
  required DateTime now,
}) {
  if (year == null || month == null || day == null) {
    return const Err(DobValidationFailure.incomplete);
  }

  final constructed = DateTime(year, month, day);
  if (constructed.year != year ||
      constructed.month != month ||
      constructed.day != day) {
    return const Err(DobValidationFailure.invalidDate);
  }

  final today = DateTime(now.year, now.month, now.day);
  if (constructed.isAfter(today)) {
    return const Err(DobValidationFailure.inFuture);
  }

  var age = today.year - year;
  if (today.month < month || (today.month == month && today.day < day)) {
    age--;
  }
  if (age < AgePolicy.minAgeYears) {
    return const Err(DobValidationFailure.tooYoung);
  }

  return Ok(DateOfBirth(year: year, month: month, day: day));
}
