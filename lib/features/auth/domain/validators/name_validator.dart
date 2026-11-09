import '../../../../core/errors/result.dart';
import '../failures/name_validation_failure.dart';

const _maxNameLength = 50;
/// Myanmar and similar scripts use vowel signs (`\p{M}`) after consonants (`\p{L}`).
final _letterPattern = RegExp(r'^[\p{L}\p{M} ]+$', unicode: true);
final _digitPattern = RegExp(r'\d');

Result<String, NameValidationFailure> validateFirstName(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return const Err(NameValidationFailure.empty);
  return _validateNonEmptyName(trimmed);
}

Result<String?, NameValidationFailure> validateLastName(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return const Ok(null);
  return _validateNonEmptyName(trimmed);
}

Result<String, NameValidationFailure> _validateNonEmptyName(String trimmed) {
  if (trimmed.length > _maxNameLength) {
    return const Err(NameValidationFailure.tooLong);
  }
  if (_digitPattern.hasMatch(trimmed)) {
    return const Err(NameValidationFailure.containsDigit);
  }
  if (!_letterPattern.hasMatch(trimmed)) {
    return const Err(NameValidationFailure.invalidCharacters);
  }
  return Ok(trimmed);
}
