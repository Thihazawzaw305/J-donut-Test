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

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

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
  /// **'First Name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last Name (Optional)'**
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

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the\nworld of J\'donuts'**
  String get welcomeHeadline;

  /// No description provided for @letsExplore.
  ///
  /// In en, this message translates to:
  /// **'Let\'s explore'**
  String get letsExplore;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavHome;

  /// No description provided for @homeNavReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get homeNavReward;

  /// No description provided for @homeNavOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get homeNavOrder;

  /// No description provided for @homeNavWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get homeNavWallet;

  /// No description provided for @homeNavSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeNavSettings;

  /// No description provided for @homeOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing saved catalog.'**
  String get homeOfflineBanner;

  /// No description provided for @memberSubtitleEwallet.
  ///
  /// In en, this message translates to:
  /// **'Bronze member'**
  String get memberSubtitleEwallet;

  /// No description provided for @memberSubtitleSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver member'**
  String get memberSubtitleSilver;

  /// No description provided for @memberTierProgressSilver.
  ///
  /// In en, this message translates to:
  /// **'{kyats} kyats left to become Silver'**
  String memberTierProgressSilver(String kyats);

  /// No description provided for @memberTierProgressGold.
  ///
  /// In en, this message translates to:
  /// **'{points} points left to become Gold member'**
  String memberTierProgressGold(String points);

  /// No description provided for @homeSectionSeasonal.
  ///
  /// In en, this message translates to:
  /// **'Seasonal specials'**
  String get homeSectionSeasonal;

  /// No description provided for @homeSectionPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get homeSectionPopular;

  /// No description provided for @homeSectionOrderAgain.
  ///
  /// In en, this message translates to:
  /// **'Order again'**
  String get homeSectionOrderAgain;

  /// No description provided for @homeSectionDonuts.
  ///
  /// In en, this message translates to:
  /// **'Donuts'**
  String get homeSectionDonuts;

  /// No description provided for @homeSectionBread.
  ///
  /// In en, this message translates to:
  /// **'Bread'**
  String get homeSectionBread;

  /// No description provided for @homeSectionCookies.
  ///
  /// In en, this message translates to:
  /// **'Cookies'**
  String get homeSectionCookies;

  /// No description provided for @homeSectionCake.
  ///
  /// In en, this message translates to:
  /// **'Cake'**
  String get homeSectionCake;

  /// No description provided for @homeShopsNearby.
  ///
  /// In en, this message translates to:
  /// **'There are {count} J\'Donut shops near you.'**
  String homeShopsNearby(int count);

  /// No description provided for @homeExploreNow.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE NOW'**
  String get homeExploreNow;

  /// No description provided for @homeOrderOnline.
  ///
  /// In en, this message translates to:
  /// **'Order online'**
  String get homeOrderOnline;

  /// No description provided for @seeAllAction.
  ///
  /// In en, this message translates to:
  /// **'See all products'**
  String get seeAllAction;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @rewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsTitle;

  /// No description provided for @rewardsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'J\' Donuts Rewards'**
  String get rewardsScreenTitle;

  /// No description provided for @rewardsPillLabel.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsPillLabel;

  /// No description provided for @rewardsTierSilverTitle.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get rewardsTierSilverTitle;

  /// No description provided for @rewardsTierGoldTitle.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get rewardsTierGoldTitle;

  /// No description provided for @rewardsTierPlatinumTitle.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get rewardsTierPlatinumTitle;

  /// No description provided for @rewardsTierSilverSubtitleHere.
  ///
  /// In en, this message translates to:
  /// **'You\'re here now'**
  String get rewardsTierSilverSubtitleHere;

  /// No description provided for @rewardsTierGoldSubtitlePoints.
  ///
  /// In en, this message translates to:
  /// **'{points} pts Remaining to become Gold'**
  String rewardsTierGoldSubtitlePoints(String points);

  /// No description provided for @rewardsTierPlatinumSubtitleSoon.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be here soon'**
  String get rewardsTierPlatinumSubtitleSoon;

  /// No description provided for @rewardsTotalPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total points'**
  String get rewardsTotalPointsLabel;

  /// No description provided for @rewardsEatMoreEarnMore.
  ///
  /// In en, this message translates to:
  /// **'Eat more earn more'**
  String get rewardsEatMoreEarnMore;

  /// No description provided for @rewardsGiftTab.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get rewardsGiftTab;

  /// No description provided for @rewardsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load rewards. Try again.'**
  String get rewardsLoadError;

  /// No description provided for @rewardsEmptyMember.
  ///
  /// In en, this message translates to:
  /// **'No member profile found.'**
  String get rewardsEmptyMember;

  /// No description provided for @challengeEatCocoDonuts.
  ///
  /// In en, this message translates to:
  /// **'Eat 4 Coco donuts'**
  String get challengeEatCocoDonuts;

  /// No description provided for @challengeDrinkAmericano.
  ///
  /// In en, this message translates to:
  /// **'Drink 12 cups americano'**
  String get challengeDrinkAmericano;

  /// No description provided for @rewardsEarn.
  ///
  /// In en, this message translates to:
  /// **'EARN'**
  String get rewardsEarn;

  /// No description provided for @rewardsPtsLabel.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String rewardsPtsLabel(int points);

  /// No description provided for @rewardsChallengeProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String rewardsChallengeProgress(int current, int total);

  /// No description provided for @rewardsGiftEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Promotion Found'**
  String get rewardsGiftEmpty;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @storesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get storesTitle;

  /// No description provided for @productCoconutDonut.
  ///
  /// In en, this message translates to:
  /// **'Coconut Donut'**
  String get productCoconutDonut;

  /// No description provided for @productMonsterBlackFlake.
  ///
  /// In en, this message translates to:
  /// **'Monster Black Flake'**
  String get productMonsterBlackFlake;

  /// No description provided for @productChocolateBrownie.
  ///
  /// In en, this message translates to:
  /// **'Chocolate Browine'**
  String get productChocolateBrownie;

  /// No description provided for @productFancyClover.
  ///
  /// In en, this message translates to:
  /// **'Fancy Clover'**
  String get productFancyClover;

  /// No description provided for @productCandyRing.
  ///
  /// In en, this message translates to:
  /// **'Candy Ring'**
  String get productCandyRing;

  /// No description provided for @productHappyBloom.
  ///
  /// In en, this message translates to:
  /// **'Happy Bloom'**
  String get productHappyBloom;

  /// No description provided for @productButterCreamBread.
  ///
  /// In en, this message translates to:
  /// **'Butter Cream Bread'**
  String get productButterCreamBread;

  /// No description provided for @productCheeseBread.
  ///
  /// In en, this message translates to:
  /// **'Cheese Bread'**
  String get productCheeseBread;

  /// No description provided for @productBreadSticks.
  ///
  /// In en, this message translates to:
  /// **'Bread Sticks'**
  String get productBreadSticks;

  /// No description provided for @productButterBiscuit.
  ///
  /// In en, this message translates to:
  /// **'Butter Biscuit 12\'s'**
  String get productButterBiscuit;

  /// No description provided for @productButtercake10.
  ///
  /// In en, this message translates to:
  /// **'Buttercake 10\'s'**
  String get productButtercake10;

  /// No description provided for @productButtercake6.
  ///
  /// In en, this message translates to:
  /// **'Buttercake 6\'s'**
  String get productButtercake6;

  /// No description provided for @productJbitesChocolate.
  ///
  /// In en, this message translates to:
  /// **'J\'Bites Chocolate'**
  String get productJbitesChocolate;

  /// No description provided for @productCoconutDescription.
  ///
  /// In en, this message translates to:
  /// **'Enjoy our scrumptious coconut donut, lightly glazed and perfect with coffee.'**
  String get productCoconutDescription;

  /// No description provided for @productMonsterDescription.
  ///
  /// In en, this message translates to:
  /// **'Monster Black Flake donut topped with chocolate flake and candy eyes.'**
  String get productMonsterDescription;

  /// No description provided for @productBrownieDescription.
  ///
  /// In en, this message translates to:
  /// **'Rich chocolate brownie baked fresh daily.'**
  String get productBrownieDescription;

  /// No description provided for @productFancyCloverDescription.
  ///
  /// In en, this message translates to:
  /// **'Fancy clover donut with pastel glaze.'**
  String get productFancyCloverDescription;

  /// No description provided for @productGenericDonutDescription.
  ///
  /// In en, this message translates to:
  /// **'A fun J\'Donuts treat made fresh for you.'**
  String get productGenericDonutDescription;

  /// No description provided for @productBreadDescription.
  ///
  /// In en, this message translates to:
  /// **'Soft bakery bread from J\'Donuts.'**
  String get productBreadDescription;

  /// No description provided for @productCookieDescription.
  ///
  /// In en, this message translates to:
  /// **'Crispy cookies and sticks, perfect for sharing.'**
  String get productCookieDescription;

  /// No description provided for @productCakeDescription.
  ///
  /// In en, this message translates to:
  /// **'Buttercake slices packed for the family.'**
  String get productCakeDescription;

  /// No description provided for @productJbitesDescription.
  ///
  /// In en, this message translates to:
  /// **'Bite-size donut balls dusted with sugar.'**
  String get productJbitesDescription;

  /// No description provided for @shopMyaynigone.
  ///
  /// In en, this message translates to:
  /// **'Myaynigone J\'Donut'**
  String get shopMyaynigone;

  /// No description provided for @shopMyaynigoneAddress.
  ///
  /// In en, this message translates to:
  /// **'2972 Pyay Road, Sanchaung Township, Yangon'**
  String get shopMyaynigoneAddress;

  /// No description provided for @shopBoAungKyaw.
  ///
  /// In en, this message translates to:
  /// **'Bo Aung Kyaw'**
  String get shopBoAungKyaw;

  /// No description provided for @shopBoAungKyawAddress.
  ///
  /// In en, this message translates to:
  /// **'No.(144/146), 29th Street, Pabedan Township, Yangon'**
  String get shopBoAungKyawAddress;

  /// No description provided for @shopHledan.
  ///
  /// In en, this message translates to:
  /// **'Hledan'**
  String get shopHledan;

  /// No description provided for @shopHledanAddress.
  ///
  /// In en, this message translates to:
  /// **'No.(286/B), Hledan Road, Kamayut Township, Yangon'**
  String get shopHledanAddress;

  /// No description provided for @productCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Product code'**
  String get productCodeLabel;

  /// No description provided for @productWhatsThis.
  ///
  /// In en, this message translates to:
  /// **'What\'s this?'**
  String get productWhatsThis;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'ADD TO CART'**
  String get addToCart;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get productNotFound;

  /// No description provided for @productFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get productFavorite;

  /// No description provided for @quantityDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get quantityDecrease;

  /// No description provided for @quantityIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get quantityIncrease;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @homeRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get homeRetry;

  /// No description provided for @homeEmptyCatalog.
  ///
  /// In en, this message translates to:
  /// **'No catalog data yet.'**
  String get homeEmptyCatalog;

  /// No description provided for @homeSectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here right now.'**
  String get homeSectionEmpty;

  /// No description provided for @homeSectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this section.'**
  String get homeSectionError;

  /// No description provided for @homeCatalogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading the catalog.'**
  String get homeCatalogLoadError;

  /// No description provided for @productDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productDetailTitle;

  /// No description provided for @discountBadge.
  ///
  /// In en, this message translates to:
  /// **'-{percent}%'**
  String discountBadge(int percent);

  /// No description provided for @productNewBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get productNewBadge;
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
