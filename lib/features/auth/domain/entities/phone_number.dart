/// A validated Myanmar mobile number, stored without country code.
final class PhoneNumber {
  const PhoneNumber(this.nationalNumber);

  static const countryCode = '+95';

  final String nationalNumber;

  String get e164 => '$countryCode$nationalNumber';

  @override
  bool operator ==(Object other) =>
      other is PhoneNumber && other.nationalNumber == nationalNumber;

  @override
  int get hashCode => nationalNumber.hashCode;
}
