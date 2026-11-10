import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/failures/name_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/validators/name_validator.dart';

void main() {
  group('validateFirstName', () {
    test('rejects blank input as empty', () {
      expect(validateFirstName('').errorOrNull, NameValidationFailure.empty);
    });

    test('rejects more than fifty characters as tooLong', () {
      expect(
        validateFirstName('a' * 51).errorOrNull,
        NameValidationFailure.tooLong,
      );
    });

    test('rejects a digit as containsDigit', () {
      expect(
        validateFirstName('John2').errorOrNull,
        NameValidationFailure.containsDigit,
      );
    });

    test('rejects punctuation as invalidCharacters', () {
      expect(
        validateFirstName('John@').errorOrNull,
        NameValidationFailure.invalidCharacters,
      );
    });

    test('accepts Myanmar letters', () {
      expect(validateFirstName('သီဟ').valueOrNull, 'သီဟ');
    });

    test('trims surrounding whitespace on success', () {
      expect(validateFirstName('  Alice  ').valueOrNull, 'Alice');
    });
  });

  group('validateLastName', () {
    test('accepts blank input as null', () {
      expect(validateLastName('').valueOrNull, isNull);
    });

    test('accepts whitespace-only input as null', () {
      expect(validateLastName('   ').valueOrNull, isNull);
    });

    test('rejects more than fifty characters as tooLong', () {
      expect(
        validateLastName('b' * 51).errorOrNull,
        NameValidationFailure.tooLong,
      );
    });

    test('rejects a digit as containsDigit', () {
      expect(
        validateLastName('Smith1').errorOrNull,
        NameValidationFailure.containsDigit,
      );
    });

    test('accepts valid last name when provided', () {
      expect(validateLastName('Smith').valueOrNull, 'Smith');
    });

    test('accepts Myanmar letters', () {
      expect(validateLastName('သီဟ').valueOrNull, 'သီဟ');
    });

    test('rejects punctuation as invalidCharacters', () {
      expect(
        validateLastName('Smith-').errorOrNull,
        NameValidationFailure.invalidCharacters,
      );
    });
  });
}
