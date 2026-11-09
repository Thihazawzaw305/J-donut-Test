import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';

void main() {
  test('e164 prefixes the national number with +95', () {
    expect(const PhoneNumber('9254135592').e164, '+959254135592');
  });

  test('numbers with the same national digits are equal', () {
    expect(const PhoneNumber('912345678'), const PhoneNumber('912345678'));
  });
}
