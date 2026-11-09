import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'J\'Donuts'**
  String get appName;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @legalNoticePrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you acknowledge that you have read and agree to our '**
  String get legalNoticePrefix;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @legalNoticeConjunction.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get legalNoticeConjunction;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @legalNoticeSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get legalNoticeSuffix;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepProgress(int current, int total);

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneTitle;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'9 xxx xxx xxx'**
  String get phoneHint;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @phoneErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number.'**
  String get phoneErrorEmpty;

  /// No description provided for @phoneErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Myanmar mobile number, like 09 123 456 789.'**
  String get phoneErrorInvalid;

  /// No description provided for @authErrorNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This number isn\'t registered yet.'**
  String get authErrorNotRegistered;

  /// No description provided for @authErrorAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This number is already registered. Please log in.'**
  String get authErrorAlreadyRegistered;

  /// No description provided for @authErrorWrongOtp.
  ///
  /// In en, this message translates to:
  /// **'That code doesn\'t match. Try again.'**
  String get authErrorWrongOtp;

  /// No description provided for @authErrorOtpLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Request a new code.'**
  String get authErrorOtpLocked;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @verifyNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get verifyNumberTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent 6 digit OTP to {e164}'**
  String otpSentTo(String e164);

  /// No description provided for @otpResendPrompt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get otpResendPrompt;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'resend in {mm} : {ss} min'**
  String otpResendIn(String mm, String ss);

  /// No description provided for @otpErrorWrong.
  ///
  /// In en, this message translates to:
  /// **'That code is incorrect.'**
  String get otpErrorWrong;

  /// No description provided for @otpErrorLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Resend a new code.'**
  String get otpErrorLocked;

  /// No description provided for @otpErrorIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Enter all 6 digits.'**
  String get otpErrorIncomplete;

  /// No description provided for @otpErrorNonDigit.
  ///
  /// In en, this message translates to:
  /// **'Use numbers only.'**
  String get otpErrorNonDigit;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name (optional)'**
  String get lastNameHint;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get nameTitle;

  /// No description provided for @firstNameErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name.'**
  String get firstNameErrorEmpty;

  /// No description provided for @firstNameErrorTooLong.
  ///
  /// In en, this message translates to:
  /// **'First name must be 50 characters or fewer.'**
  String get firstNameErrorTooLong;

  /// No description provided for @firstNameErrorContainsDigit.
  ///
  /// In en, this message translates to:
  /// **'Names can\'t include numbers.'**
  String get firstNameErrorContainsDigit;

  /// No description provided for @firstNameErrorInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'Use letters and spaces only.'**
  String get firstNameErrorInvalidCharacters;

  /// No description provided for @lastNameErrorTooLong.
  ///
  /// In en, this message translates to:
  /// **'Last name must be 50 characters or fewer.'**
  String get lastNameErrorTooLong;

  /// No description provided for @lastNameErrorContainsDigit.
  ///
  /// In en, this message translates to:
  /// **'Names can\'t include numbers.'**
  String get lastNameErrorContainsDigit;

  /// No description provided for @lastNameErrorInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'Use letters and spaces only.'**
  String get lastNameErrorInvalidCharacters;

  /// No description provided for @dobTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your date of birth?'**
  String get dobTitle;

  /// No description provided for @dayHint.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayHint;

  /// No description provided for @monthHint.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthHint;

  /// No description provided for @yearHint.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearHint;

  /// No description provided for @selectBirthday.
  ///
  /// In en, this message translates to:
  /// **'Select your Birthday'**
  String get selectBirthday;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @dobErrorIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Enter your full date of birth.'**
  String get dobErrorIncomplete;

  /// No description provided for @dobErrorInvalidDate.
  ///
  /// In en, this message translates to:
  /// **'That\'s not a valid date.'**
  String get dobErrorInvalidDate;

  /// No description provided for @dobErrorInFuture.
  ///
  /// In en, this message translates to:
  /// **'Birth date can\'t be in the future.'**
  String get dobErrorInFuture;

  /// No description provided for @dobErrorTooYoung.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old.'**
  String get dobErrorTooYoung;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
