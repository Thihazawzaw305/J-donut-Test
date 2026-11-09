import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/validators/phone_input_normalizer.dart';

void main() {
  group('normalizePhoneInputForDisplay', () {
    test('removes a single leading zero from digits', () {
      expect(normalizePhoneInputForDisplay('09254135592'), '9254135592');
    });

    test('removes leading zero but keeps spacing', () {
      expect(normalizePhoneInputForDisplay('09-254 135 592'), '9-254 135 592');
    });

    test('does not remove a second zero after the first digit', () {
      expect(normalizePhoneInputForDisplay('09001234567'), '9001234567');
    });

    test('leaves input without a leading zero unchanged', () {
      expect(normalizePhoneInputForDisplay('9254135592'), '9254135592');
    });

    test('typing only zero clears the visible field', () {
      expect(normalizePhoneInputForDisplay('0'), '');
    });
  });
}
