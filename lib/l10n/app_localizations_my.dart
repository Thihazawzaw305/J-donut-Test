// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appName => 'J\'Donuts';

  @override
  String get getStarted => 'စတင်ကြရအောင်';

  @override
  String get alreadyHaveAccount => 'အကောင့်ရှိပြီးသားလား။';

  @override
  String get logIn => 'အကောင့်ဝင်မည်';

  @override
  String get continueWithGoogle => 'Google ဖြင့် ဆက်လုပ်မည်';

  @override
  String get continueWithFacebook => 'Facebook ဖြင့် ဆက်လုပ်မည်';

  @override
  String get continueWithApple => 'Apple ဖြင့် ဆက်လုပ်မည်';

  @override
  String get legalNoticePrefix => 'ဆက်လုပ်ခြင်းဖြင့် ကျွန်ုပ်တို့၏ ';

  @override
  String get termsOfUse => 'အသုံးပြုမှု စည်းမျဉ်းများ';

  @override
  String get legalNoticeConjunction => ' နှင့် ';

  @override
  String get privacyPolicy => 'ကိုယ်ရေးအချက်အလက် မူဝါဒ';

  @override
  String get legalNoticeSuffix =>
      ' ကို ဖတ်ရှုပြီး သဘောတူကြောင်း အသိအမှတ်ပြုပါသည်။';

  @override
  String get comingSoon => 'မကြာမီ လာမည်';

  @override
  String get back => 'နောက်သို့';

  @override
  String stepProgress(int current, int total) {
    return 'အဆင့် $total ဆင့်အနက် $current';
  }

  @override
  String get phoneTitle => 'သင့်ဖုန်းနံပါတ် ထည့်ပါ';

  @override
  String get phoneHint => '9 xxx xxx xxx';

  @override
  String get continueLabel => 'ဆက်လုပ်မည်';

  @override
  String get phoneErrorEmpty => 'သင့်ဖုန်းနံပါတ် ထည့်ပါ။';

  @override
  String get phoneErrorInvalid =>
      '09 123 456 789 ကဲ့သို့ မှန်ကန်သော မြန်မာဖုန်းနံပါတ် ထည့်ပါ။';

  @override
  String get authErrorNotRegistered => 'ဤနံပါတ်ကို မှတ်ပုံမတင်ရသေးပါ။';

  @override
  String get authErrorAlreadyRegistered =>
      'ဤနံပါတ်ကို မှတ်ပုံတင်ပြီးဖြစ်သည်။ အကောင့်ဝင်ပါ။';

  @override
  String get authErrorWrongOtp => 'ကုဒ် မကိုက်ညီပါ။ ထပ်ကြိုးစားပါ။';

  @override
  String get authErrorOtpLocked =>
      'ကြိုးစားမှု များလွန်းသည်။ ကုဒ်အသစ် တောင်းပါ။';

  @override
  String get registerAction => 'မှတ်ပုံတင်မည်';

  @override
  String get verifyNumberTitle => 'သင့်နံပါတ်ကို အတည်ပြုပါ';

  @override
  String get loading => 'ခေတ္တစောင့်ပါ';

  @override
  String otpSentTo(String e164) {
    return '$e164 သို့ ဂဏန်း ၆ လုံး OTP ပို့ထားပါသည်';
  }

  @override
  String get otpResendPrompt => 'ကုဒ် မရရှိဘူးလား။';

  @override
  String otpResendIn(String mm, String ss) {
    return '$mm : $ss မိနစ်အကြာ ပြန်ပို့မည်';
  }

  @override
  String get otpErrorWrong => 'ကုဒ် မှားနေသည်။';

  @override
  String get otpErrorLocked => 'ကြိုးစားမှု များလွန်းသည်။ ကုဒ်အသစ် ပြန်ပို့ပါ။';

  @override
  String get otpErrorIncomplete => 'ဂဏန်း ၆ လုံးစလုံး ထည့်ပါ။';

  @override
  String get otpErrorNonDigit => 'ဂဏန်းများသာ သုံးပါ။';

  @override
  String get firstNameHint => 'အမည်';

  @override
  String get lastNameHint => 'မျိုးရိုးအမည် (မထည့်လည်းရ)';

  @override
  String get nameTitle => 'သင့်အမည် ဘယ်လိုခေါ်ပါသလဲ။';

  @override
  String get firstNameErrorEmpty => 'သင့်အမည် ထည့်ပါ။';

  @override
  String get firstNameErrorTooLong => 'အမည်သည် စာလုံး ၅၀ ထက် မပိုရပါ။';

  @override
  String get firstNameErrorContainsDigit => 'အမည်တွင် ဂဏန်း မပါရပါ။';

  @override
  String get firstNameErrorInvalidCharacters =>
      'စာလုံးနှင့် နေရာလွတ်များသာ သုံးပါ။';

  @override
  String get lastNameErrorTooLong => 'မျိုးရိုးအမည်သည် စာလုံး ၅၀ ထက် မပိုရပါ။';

  @override
  String get lastNameErrorContainsDigit => 'အမည်တွင် ဂဏန်း မပါရပါ။';

  @override
  String get lastNameErrorInvalidCharacters =>
      'စာလုံးနှင့် နေရာလွတ်များသာ သုံးပါ။';

  @override
  String get dobTitle => 'သင့်မွေးနေ့ ဘယ်နေ့လဲ။';

  @override
  String get dayHint => 'ရက်';

  @override
  String get monthHint => 'လ';

  @override
  String get yearHint => 'နှစ်';

  @override
  String get selectBirthday => 'သင့်မွေးနေ့ ရွေးပါ';

  @override
  String get select => 'ရွေးမည်';

  @override
  String get close => 'ပိတ်မည်';

  @override
  String get creating => 'ဖန်တီးနေသည်...';

  @override
  String get dobErrorIncomplete => 'မွေးနေ့ အပြည့်အစုံ ထည့်ပါ။';

  @override
  String get dobErrorInvalidDate => 'မှန်ကန်သော ရက်စွဲ မဟုတ်ပါ။';

  @override
  String get dobErrorInFuture => 'မွေးနေ့သည် အနာဂတ်ရက် မဖြစ်ရပါ။';

  @override
  String get dobErrorTooYoung => 'အသက် အနည်းဆုံး ၁၃ နှစ် ပြည့်ရပါမည်။';

  @override
  String get welcomeTitle => 'ကြိုဆိုပါသည်';

  @override
  String get welcomeHeadline => 'J\'donuts ကမ္ဘာသို့\nကြိုဆိုပါသည်';

  @override
  String get letsExplore => 'စူးစမ်းကြရအောင်';

  @override
  String get homeTitle => 'ပင်မ';

  @override
  String get homeNavHome => 'ပင်မ';

  @override
  String get homeNavReward => 'ဆုလာဘ်';

  @override
  String get homeNavOrder => 'အော်ဒါ';

  @override
  String get homeNavWallet => 'ပိုက်ဆံအိတ်';

  @override
  String get homeNavSettings => 'ဆက်တင်';

  @override
  String get homeOfflineBanner =>
      'အော့ဖ်လိုင်း ဖြစ်နေသည်။ သိမ်းထားသော စာရင်းကို ပြနေသည်။';

  @override
  String get memberSubtitleEwallet => 'Bronze အဖွဲ့ဝင်';

  @override
  String get memberSubtitleSilver => 'Silver အဖွဲ့ဝင်';

  @override
  String memberTierProgressSilver(String kyats) {
    return 'Silver ဖြစ်ရန် $kyats ကျပ် လိုသေးသည်';
  }

  @override
  String memberTierProgressGold(String points) {
    return 'Gold အဖွဲ့ဝင်ဖြစ်ရန် $points မှတ် လိုသေးသည်';
  }

  @override
  String get homeSectionSeasonal => 'ရာသီအလိုက် အထူးများ';

  @override
  String get homeSectionPopular => 'လူကြိုက်များ';

  @override
  String get homeSectionOrderAgain => 'ထပ်မံမှာယူရန်';

  @override
  String get homeSectionDonuts => 'ဒိုးနတ်';

  @override
  String get homeSectionBread => 'ပေါင်မုန့်';

  @override
  String get homeSectionCookies => 'ကွတ်ကီး';

  @override
  String get homeSectionCake => 'ကိတ်မုန့်';

  @override
  String homeShopsNearby(int count) {
    return 'သင့်အနီးတွင် J\'Donut ဆိုင် $count ဆိုင် ရှိသည်။';
  }

  @override
  String get homeExploreNow => 'ယခု ကြည့်ရှုမည်';

  @override
  String get homeOrderOnline => 'အွန်လိုင်း မှာယူမည်';

  @override
  String get seeAllAction => 'ပစ္စည်းအားလုံး ကြည့်မည်';

  @override
  String get settingsTitle => 'ဆက်တင်';

  @override
  String get logOut => 'အကောင့်ထွက်မည်';

  @override
  String get rewardsTitle => 'ဆုလာဘ်များ';

  @override
  String get rewardsScreenTitle => 'J\' Donuts ဆုလာဘ်များ';

  @override
  String get rewardsPillLabel => 'ဆုလာဘ်';

  @override
  String get rewardsTierSilverTitle => 'Silver';

  @override
  String get rewardsTierGoldTitle => 'Gold';

  @override
  String get rewardsTierPlatinumTitle => 'Platinum';

  @override
  String get rewardsTierSilverSubtitleHere => 'ယခု ဤနေရာတွင် ရှိသည်';

  @override
  String rewardsTierGoldSubtitlePoints(String points) {
    return 'Gold ဖြစ်ရန် $points မှတ် လိုသေးသည်';
  }

  @override
  String get rewardsTierPlatinumSubtitleSoon => 'မကြာမီ ဤနေရာ ရောက်မည်';

  @override
  String get rewardsTotalPointsLabel => 'စုစုပေါင်း အမှတ်';

  @override
  String get rewardsEatMoreEarnMore => 'များများစား များများရ';

  @override
  String get rewardsGiftTab => 'လက်ဆောင်';

  @override
  String get rewardsLoadError => 'ဆုလာဘ်များ ဖွင့်မရပါ။ ထပ်ကြိုးစားပါ။';

  @override
  String get rewardsEmptyMember => 'အဖွဲ့ဝင် ပရိုဖိုင် မတွေ့ပါ။';

  @override
  String get challengeEatCocoDonuts => 'Coco ဒိုးနတ် ၄ ခု စားပါ';

  @override
  String get challengeDrinkAmericano => 'Americano ၁၂ ခွက် သောက်ပါ';

  @override
  String get rewardsEarn => 'ရယူမည်';

  @override
  String rewardsPtsLabel(int points) {
    return '$points မှတ်';
  }

  @override
  String rewardsChallengeProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String get rewardsGiftEmpty => 'ပရိုမိုးရှင်း မတွေ့ပါ';

  @override
  String get walletTitle => 'ပိုက်ဆံအိတ်';

  @override
  String get storesTitle => 'ဆိုင်များ';

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
  String get productCodeLabel => 'ပစ္စည်းကုဒ်';

  @override
  String get productWhatsThis => 'ဒါဘာလဲ။';

  @override
  String get addToCart => 'ခြင်းထဲ ထည့်မည်';

  @override
  String get productNotFound => 'ပစ္စည်း မတွေ့ပါ။';

  @override
  String get productFavorite => 'အကြိုက်ဆုံး';

  @override
  String get quantityDecrease => 'အရေအတွက် လျှော့မည်';

  @override
  String get quantityIncrease => 'အရေအတွက် တိုးမည်';

  @override
  String get addedToCart => 'ခြင်းထဲ ထည့်ပြီးပါပြီ';

  @override
  String get homeRetry => 'ထပ်ကြိုးစားမည်';

  @override
  String get homeEmptyCatalog => 'စာရင်း ဒေတာ မရှိသေးပါ။';

  @override
  String get homeSectionEmpty => 'လောလောဆယ် ဘာမှ မရှိပါ။';

  @override
  String get homeSectionError => 'ဤအပိုင်းကို ဖွင့်မရပါ။';

  @override
  String get homeCatalogLoadError =>
      'စာရင်း ဖွင့်ရာတွင် အမှားတစ်ခု ဖြစ်သွားသည်။';

  @override
  String get productDetailTitle => 'ပစ္စည်း';

  @override
  String discountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get productNewBadge => 'အသစ်';
}
