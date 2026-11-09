import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/dob_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/name_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/otp_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/phone_validation_failure.dart';
import 'package:j_donuts_app/features/auth/presentation/mappers/failure_messages.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('maps phone validation failures to localized text', () {
    expect(PhoneValidationFailure.empty.message(l10n), l10n.phoneErrorEmpty);
    expect(
      PhoneValidationFailure.invalidFormat.message(l10n),
      l10n.phoneErrorInvalid,
    );
  });

  test('maps auth failures to localized text', () {
    expect(
      AuthFailure.notRegistered.message(l10n),
      l10n.authErrorNotRegistered,
    );
    expect(
      AuthFailure.alreadyRegistered.message(l10n),
      l10n.authErrorAlreadyRegistered,
    );
    expect(AuthFailure.wrongOtp.message(l10n), l10n.otpErrorWrong);
    expect(AuthFailure.otpLocked.message(l10n), l10n.otpErrorLocked);
  });

  test('maps otp validation failures to localized text', () {
    expect(
      OtpValidationFailure.incomplete.message(l10n),
      l10n.otpErrorIncomplete,
    );
    expect(
      OtpValidationFailure.nonDigit.message(l10n),
      l10n.otpErrorNonDigit,
    );
  });

  test('maps name validation failures to localized text', () {
    expect(
      NameValidationFailure.empty.message(l10n, isFirstName: true),
      l10n.firstNameErrorEmpty,
    );
    expect(
      NameValidationFailure.tooLong.message(l10n, isFirstName: true),
      l10n.firstNameErrorTooLong,
    );
    expect(
      NameValidationFailure.containsDigit.message(l10n, isFirstName: false),
      l10n.lastNameErrorContainsDigit,
    );
    expect(
      NameValidationFailure.invalidCharacters.message(l10n, isFirstName: false),
      l10n.lastNameErrorInvalidCharacters,
    );
  });

  test('maps date-of-birth validation failures to localized text', () {
    expect(
      DobValidationFailure.incomplete.message(l10n),
      l10n.dobErrorIncomplete,
    );
    expect(
      DobValidationFailure.tooYoung.message(l10n),
      l10n.dobErrorTooYoung,
    );
  });
}
