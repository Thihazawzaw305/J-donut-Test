class OtpCode {
  const OtpCode(this.digits);

  final String digits;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is OtpCode && other.digits == digits;

  @override
  int get hashCode => digits.hashCode;
}
