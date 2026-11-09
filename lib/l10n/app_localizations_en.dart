// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'J\'Donuts';

  @override
  String get getStarted => 'Let\'s get started';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logIn => 'Log In';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get legalNoticePrefix =>
      'By continuing, you acknowledge that you have read and agree to our ';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get legalNoticeConjunction => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get legalNoticeSuffix => '.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get back => 'Back';

  @override
  String stepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get phoneTitle => 'Enter your phone number';

  @override
  String get phoneHint => '9 xxx xxx xxx';

  @override
  String get continueLabel => 'Continue';

  @override
  String get phoneErrorEmpty => 'Please enter your phone number.';

  @override
  String get phoneErrorInvalid =>
      'Enter a valid Myanmar mobile number, like 09 123 456 789.';

  @override
  String get authErrorNotRegistered => 'This number isn\'t registered yet.';

  @override
  String get authErrorAlreadyRegistered =>
      'This number is already registered. Please log in.';

  @override
  String get registerAction => 'Register';

  @override
  String get verifyNumberTitle => 'Verify your number';
}
