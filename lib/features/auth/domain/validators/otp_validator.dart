import '../../../../core/errors/result.dart';
import '../entities/otp_code.dart';
import '../failures/otp_validation_failure.dart';
import '../policies/otp_policy.dart';

final _digitPattern = RegExp(r'^\d+$');

Result<OtpCode, OtpValidationFailure> validateOtp(String raw) {
  final digits = raw.replaceAll(' ', '');
  if (digits.length != OtpPolicy.codeLength) {
    return const Err(OtpValidationFailure.incomplete);
  }
  if (!_digitPattern.hasMatch(digits)) {
    return const Err(OtpValidationFailure.nonDigit);
  }
  return Ok(OtpCode(digits));
}
