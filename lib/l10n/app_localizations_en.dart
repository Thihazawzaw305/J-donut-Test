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
  String get onboardingHeadline => 'Round food for every mood';

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
  String get continueWithApple => 'Continue with Apple';

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
  String get lastNameHint => 'Last Name (Optional)';

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
  String get welcomeHeadline => 'Welcome to the\nworld of J\'donuts';

  @override
  String get letsExplore => 'Let\'s explore';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeNavHome => 'Home';

  @override
  String get homeNavReward => 'Reward';

  @override
  String get homeNavOrder => 'Order';

  @override
  String get homeNavWallet => 'Wallet';

  @override
  String get homeNavSettings => 'Settings';

  @override
  String get homeOfflineBanner => 'You\'re offline. Showing saved catalog.';

  @override
  String get memberSubtitleEwallet => 'Bronze member';

  @override
  String get memberSubtitleSilver => 'Silver member';

  @override
  String memberTierProgressSilver(String kyats) {
    return '$kyats kyats left to become Silver';
  }

  @override
  String memberTierProgressGold(String points) {
    return '$points points left to become Gold member';
  }

  @override
  String get homeSectionSeasonal => 'Seasonal specials';

  @override
  String get homeSectionPopular => 'Popular';

  @override
  String get homeSectionOrderAgain => 'Order again';

  @override
  String get homeSectionDonuts => 'Donuts';

  @override
  String get homeSectionBread => 'Bread';

  @override
  String get homeSectionCookies => 'Cookies';

  @override
  String get homeSectionCake => 'Cake';

  @override
  String homeShopsNearby(int count) {
    return 'There are $count J\'Donut shops near you.';
  }

  @override
  String get homeExploreNow => 'EXPLORE NOW';

  @override
  String get homeOrderOnline => 'Order online';

  @override
  String get seeAllAction => 'See all products';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get logOut => 'Log out';

  @override
  String get rewardsTitle => 'Rewards';

  @override
  String get rewardsScreenTitle => 'J\' Donuts Rewards';

  @override
  String get rewardsPillLabel => 'Rewards';

  @override
  String get rewardsTierSilverTitle => 'Silver';

  @override
  String get rewardsTierGoldTitle => 'Gold';

  @override
  String get rewardsTierPlatinumTitle => 'Platinum';

  @override
  String get rewardsTierSilverSubtitleHere => 'You\'re here now';

  @override
  String rewardsTierGoldSubtitlePoints(String points) {
    return '$points pts Remaining to become Gold';
  }

  @override
  String get rewardsTierPlatinumSubtitleSoon => 'You\'ll be here soon';

  @override
  String get rewardsTotalPointsLabel => 'Total points';

  @override
  String get rewardsEatMoreEarnMore => 'Eat more earn more';

  @override
  String get rewardsGiftTab => 'Gift';

  @override
  String get rewardsLoadError => 'Couldn\'t load rewards. Try again.';

  @override
  String get rewardsEmptyMember => 'No member profile found.';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get storesTitle => 'Stores';

  @override
  String get productCoconutDonut => 'Coconut Donut';

  @override
  String get productMonsterBlackFlake => 'Monster Black Flake';

  @override
  String get productChocolateBrownie => 'Chocolate Browine';

  @override
  String get productFancyClover => 'Fancy Clover';

  @override
  String get productCandyRing => 'Candy Ring';

  @override
  String get productHappyBloom => 'Happy Bloom';

  @override
  String get productButterCreamBread => 'Butter Cream Bread';

  @override
  String get productCheeseBread => 'Cheese Bread';

  @override
  String get productBreadSticks => 'Bread Sticks';

  @override
  String get productButterBiscuit => 'Butter Biscuit 12\'s';

  @override
  String get productButtercake10 => 'Buttercake 10\'s';

  @override
  String get productButtercake6 => 'Buttercake 6\'s';

  @override
  String get productJbitesChocolate => 'J\'Bites Chocolate';

  @override
  String get productCoconutDescription =>
      'Enjoy our scrumptious coconut donut, lightly glazed and perfect with coffee.';

  @override
  String get productMonsterDescription =>
      'Monster Black Flake donut topped with chocolate flake and candy eyes.';

  @override
  String get productBrownieDescription =>
      'Rich chocolate brownie baked fresh daily.';

  @override
  String get productFancyCloverDescription =>
      'Fancy clover donut with pastel glaze.';

  @override
  String get productGenericDonutDescription =>
      'A fun J\'Donuts treat made fresh for you.';

  @override
  String get productBreadDescription => 'Soft bakery bread from J\'Donuts.';

  @override
  String get productCookieDescription =>
      'Crispy cookies and sticks, perfect for sharing.';

  @override
  String get productCakeDescription =>
      'Buttercake slices packed for the family.';

  @override
  String get productJbitesDescription =>
      'Bite-size donut balls dusted with sugar.';

  @override
  String get shopMyaynigone => 'Myaynigone J\'Donut';

  @override
  String get shopMyaynigoneAddress =>
      '2972 Pyay Road, Sanchaung Township, Yangon';

  @override
  String get shopBoAungKyaw => 'Bo Aung Kyaw';

  @override
  String get shopBoAungKyawAddress =>
      'No.(144/146), 29th Street, Pabedan Township, Yangon';

  @override
  String get shopHledan => 'Hledan';

  @override
  String get shopHledanAddress =>
      'No.(286/B), Hledan Road, Kamayut Township, Yangon';

  @override
  String get productCodeLabel => 'Product code';

  @override
  String get productWhatsThis => 'What\'s this?';

  @override
  String get addToCart => 'ADD TO CART';

  @override
  String get productNotFound => 'Product not found.';

  @override
  String get productFavorite => 'Favorite';

  @override
  String get quantityDecrease => 'Decrease quantity';

  @override
  String get quantityIncrease => 'Increase quantity';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get homeRetry => 'Try again';

  @override
  String get homeEmptyCatalog => 'No catalog data yet.';

  @override
  String get homeSectionEmpty => 'Nothing here right now.';

  @override
  String get homeSectionError => 'Could not load this section.';

  @override
  String get homeCatalogLoadError =>
      'Something went wrong loading the catalog.';

  @override
  String get productDetailTitle => 'Product';

  @override
  String discountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get productNewBadge => 'New';
}
