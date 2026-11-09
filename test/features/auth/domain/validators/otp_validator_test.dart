import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/entities/otp_code.dart';
import 'package:j_donuts_app/features/auth/domain/failures/otp_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/validators/otp_validator.dart';

void main() {
  group('validateOtp', () {
    test('rejects five digits as incomplete', () {
      expect(
        validateOtp('12345').errorOrNull,
        OtpValidationFailure.incomplete,
      );
    });

    test('rejects a letter among digits as nonDigit', () {
      expect(
        validateOtp('12345a').errorOrNull,
        OtpValidationFailure.nonDigit,
      );
    });

    test('accepts exactly six digits', () {
      final result = validateOtp('123456');
      expect(result.errorOrNull, isNull);
      expect(result.valueOrNull, const OtpCode('123456'));
    });

    test('strips spaces before validating length', () {
      final result = validateOtp('123 456');
      expect(result.errorOrNull, isNull);
      expect(result.valueOrNull, const OtpCode('123456'));
    });
  });
}
