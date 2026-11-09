import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
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
  });
}
