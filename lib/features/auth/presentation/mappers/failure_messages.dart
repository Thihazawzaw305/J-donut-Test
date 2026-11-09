import '../../../../l10n/app_localizations.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/failures/dob_validation_failure.dart';
import '../../domain/failures/name_validation_failure.dart';
import '../../domain/failures/otp_validation_failure.dart';
import '../../domain/failures/phone_validation_failure.dart';

extension PhoneValidationFailureMessage on PhoneValidationFailure {
  String message(AppLocalizations l10n) => switch (this) {
    PhoneValidationFailure.empty => l10n.phoneErrorEmpty,
    PhoneValidationFailure.invalidFormat => l10n.phoneErrorInvalid,
  };
}

extension AuthFailureMessage on AuthFailure {
  String message(AppLocalizations l10n) => switch (this) {
    AuthFailure.notRegistered => l10n.authErrorNotRegistered,
    AuthFailure.alreadyRegistered => l10n.authErrorAlreadyRegistered,
    AuthFailure.wrongOtp => l10n.otpErrorWrong,
    AuthFailure.otpLocked => l10n.otpErrorLocked,
  };
}

extension OtpValidationFailureMessage on OtpValidationFailure {
  String message(AppLocalizations l10n) => switch (this) {
    OtpValidationFailure.incomplete => l10n.otpErrorIncomplete,
    OtpValidationFailure.nonDigit => l10n.otpErrorNonDigit,
  };
}

extension NameValidationFailureMessage on NameValidationFailure {
  String message(AppLocalizations l10n, {required bool isFirstName}) =>
      switch (this) {
        NameValidationFailure.empty when isFirstName =>
          l10n.firstNameErrorEmpty,
        NameValidationFailure.tooLong when isFirstName =>
          l10n.firstNameErrorTooLong,
        NameValidationFailure.containsDigit when isFirstName =>
          l10n.firstNameErrorContainsDigit,
        NameValidationFailure.invalidCharacters when isFirstName =>
          l10n.firstNameErrorInvalidCharacters,
        NameValidationFailure.tooLong => l10n.lastNameErrorTooLong,
        NameValidationFailure.containsDigit => l10n.lastNameErrorContainsDigit,
        NameValidationFailure.invalidCharacters =>
          l10n.lastNameErrorInvalidCharacters,
        NameValidationFailure.empty => l10n.firstNameErrorEmpty,
      };
}

extension DobValidationFailureMessage on DobValidationFailure {
  String message(AppLocalizations l10n) => switch (this) {
    DobValidationFailure.incomplete => l10n.dobErrorIncomplete,
    DobValidationFailure.invalidDate => l10n.dobErrorInvalidDate,
    DobValidationFailure.inFuture => l10n.dobErrorInFuture,
    DobValidationFailure.tooYoung => l10n.dobErrorTooYoung,
  };
}
