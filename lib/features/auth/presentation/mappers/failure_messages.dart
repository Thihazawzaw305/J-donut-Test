import '../../../../l10n/app_localizations.dart';
import '../../domain/failures/auth_failure.dart';
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
  };
}
