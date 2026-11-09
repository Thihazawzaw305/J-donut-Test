abstract final class OtpPolicy {
  static const codeLength = 6;
  static const maxAttempts = 3;
  static const resendSeconds = 300;
  static const correctCode = '123456';
}
