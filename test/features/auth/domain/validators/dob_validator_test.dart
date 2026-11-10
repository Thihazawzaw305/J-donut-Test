import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/entities/date_of_birth.dart';
import 'package:j_donuts_app/features/auth/domain/failures/dob_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/validators/dob_validator.dart';

void main() {
  final now = DateTime(2026, 11, 9);

  group('validateDateOfBirth', () {
    test('rejects missing parts as incomplete', () {
      expect(
        validateDateOfBirth(year: 2000, month: 5, now: now).errorOrNull,
        DobValidationFailure.incomplete,
      );
    });

    test('rejects 31 April as invalidDate', () {
      expect(
        validateDateOfBirth(
          year: 2000,
          month: 4,
          day: 31,
          now: now,
        ).errorOrNull,
        DobValidationFailure.invalidDate,
      );
    });

    test('accepts 29 February 2024', () {
      final result = validateDateOfBirth(
        year: 2024,
        month: 2,
        day: 29,
        now: DateTime(2037, 3, 1),
      );
      expect(result.errorOrNull, isNull);
      expect(
        result.valueOrNull,
        const DateOfBirth(year: 2024, month: 2, day: 29),
      );
    });

    test('rejects 29 February 2025 as invalidDate', () {
      expect(
        validateDateOfBirth(
          year: 2025,
          month: 2,
          day: 29,
          now: now,
        ).errorOrNull,
        DobValidationFailure.invalidDate,
      );
    });

    test('rejects a date after today as inFuture', () {
      expect(
        validateDateOfBirth(
          year: 2026,
          month: 11,
          day: 10,
          now: now,
        ).errorOrNull,
        DobValidationFailure.inFuture,
      );
    });

    test('rejects the day before thirteenth birthday as tooYoung', () {
      expect(
        validateDateOfBirth(
          year: 2013,
          month: 11,
          day: 10,
          now: now,
        ).errorOrNull,
        DobValidationFailure.tooYoung,
      );
    });

    test('accepts thirteenth birthday on today', () {
      final result = validateDateOfBirth(
        year: 2013,
        month: 11,
        day: 9,
        now: now,
      );
      expect(result.errorOrNull, isNull);
      expect(
        result.valueOrNull,
        const DateOfBirth(year: 2013, month: 11, day: 9),
      );
    });
  });
}
