import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/failures/phone_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/validators/phone_validator.dart';

void main() {
  String? e164Of(String raw) => validatePhone(raw).valueOrNull?.e164;
  PhoneValidationFailure? failureOf(String raw) =>
      validatePhone(raw).errorOrNull;

  group('validatePhone', () {
    test('rejects blank input as empty', () {
      expect(failureOf(''), PhoneValidationFailure.empty);
    });

    test('treats input of only spaces and dashes as empty', () {
      expect(failureOf(' - - '), PhoneValidationFailure.empty);
    });

    test('converts local format with leading zero to E.164', () {
      expect(e164Of('09254135592'), '+959254135592');
    });

    test('accepts a number typed without the leading zero', () {
      expect(e164Of('9254135592'), '+959254135592');
    });

    test('strips spaces and dashes before validating', () {
      expect(e164Of('09-254 135 592'), '+959254135592');
    });

    test('strips only one leading zero', () {
      expect(failureOf('009254135592'), PhoneValidationFailure.invalidFormat);
    });

    test('rejects numbers that do not start with 9', () {
      expect(failureOf('08254135592'), PhoneValidationFailure.invalidFormat);
    });

    test('rejects 6 digits after the 9', () {
      expect(failureOf('9123456'), PhoneValidationFailure.invalidFormat);
    });

    test('accepts 7 digits after the 9', () {
      expect(e164Of('91234567'), '+9591234567');
    });

    test('accepts 9 digits after the 9', () {
      expect(e164Of('9123456789'), '+959123456789');
    });

    test('rejects 10 digits after the 9', () {
      expect(failureOf('91234567890'), PhoneValidationFailure.invalidFormat);
    });

    test('rejects letters', () {
      expect(failureOf('09abc123456'), PhoneValidationFailure.invalidFormat);
    });
  });
}
