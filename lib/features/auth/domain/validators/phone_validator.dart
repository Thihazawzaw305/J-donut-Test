import '../../../../core/errors/result.dart';
import '../entities/phone_number.dart';
import '../failures/phone_validation_failure.dart';

final _separators = RegExp(r'[\s-]');
final _nationalNumberPattern = RegExp(r'^9\d{7,9}$');
const _trunkPrefix = '0';

String _digitsOnly(String raw) {
  var digits = raw.replaceAll(_separators, '');
  if (digits.startsWith('+')) {
    digits = digits.substring(1);
    if (digits.startsWith('95')) digits = digits.substring(2);
  }
  return digits;
}

Result<PhoneNumber, PhoneValidationFailure> validatePhone(String raw) {
  final digits = _digitsOnly(raw);
  if (digits.isEmpty) return const Err(PhoneValidationFailure.empty);

  final national = digits.startsWith(_trunkPrefix)
      ? digits.substring(1)
      : digits;
  if (!_nationalNumberPattern.hasMatch(national)) {
    return const Err(PhoneValidationFailure.invalidFormat);
  }
  return Ok(PhoneNumber(national));
}
