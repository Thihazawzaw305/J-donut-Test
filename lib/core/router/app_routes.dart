abstract final class AppRoutes {
  static const onboarding = '/';
  static const registerPhone = '/register/phone';
  static const loginPhone = '/login/phone';
  static const registerOtp = '/register/otp';
  static const loginOtp = '/login/otp';
  static const registerName = '/register/name';
  static const registerDob = '/register/dob';
  static const welcome = '/welcome';
  static const home = '/home';
  static const rewards = '/rewards';
  static const settings = '/settings';
  static String productPath(String id) => '/product/$id';
}
