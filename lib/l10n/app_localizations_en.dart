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
  String get authErrorWrongOtp => 'That code doesn\'t match. Try again.';

  @override
  String get authErrorOtpLocked => 'Too many attempts. Request a new code.';

  @override
  String get registerAction => 'Register';

  @override
  String get verifyNumberTitle => 'Verify your number';

  @override
  String get loading => 'Loading';

  @override
  String otpSentTo(String e164) {
    return 'We\'ve sent 6 digit OTP to $e164';
  }

  @override
  String get otpResendPrompt => 'Didn\'t receive the code?';

  @override
  String otpResendIn(String mm, String ss) {
    return 'resend in $mm : $ss min';
  }

  @override
  String get otpErrorWrong => 'That code is incorrect.';

  @override
  String get otpErrorLocked => 'Too many tries. Resend a new code.';

  @override
  String get otpErrorIncomplete => 'Enter all 6 digits.';

  @override
  String get otpErrorNonDigit => 'Use numbers only.';

  @override
  String get firstNameHint => 'First Name';

  @override
  String get lastNameHint => 'Last Name';

  @override
  String get nameTitle => 'What\'s your name?';

  @override
  String get firstNameErrorEmpty => 'Please enter your first name.';

  @override
  String get firstNameErrorTooLong =>
      'First name must be 50 characters or fewer.';

  @override
  String get firstNameErrorContainsDigit => 'Names can\'t include numbers.';

  @override
  String get firstNameErrorInvalidCharacters => 'Use letters and spaces only.';

  @override
  String get lastNameErrorTooLong =>
      'Last name must be 50 characters or fewer.';

  @override
  String get lastNameErrorContainsDigit => 'Names can\'t include numbers.';

  @override
  String get lastNameErrorInvalidCharacters => 'Use letters and spaces only.';

  @override
  String get dobTitle => 'What\'s your date of birth?';

  @override
  String get dayHint => 'Day';

  @override
  String get monthHint => 'Month';

  @override
  String get yearHint => 'Year';

  @override
  String get selectBirthday => 'Select your Birthday';

  @override
  String get select => 'Select';

  @override
  String get close => 'Close';

  @override
  String get creating => 'Creating...';

  @override
  String get dobErrorIncomplete => 'Enter your full date of birth.';

  @override
  String get dobErrorInvalidDate => 'That\'s not a valid date.';

  @override
  String get dobErrorInFuture => 'Birth date can\'t be in the future.';

  @override
  String get dobErrorTooYoung => 'You must be at least 13 years old.';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get homeTitle => 'Home';
}
