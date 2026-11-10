import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/format_member_display_name.dart';

void main() {
  test('uses first name only when last is empty', () {
    expect(formatMemberDisplayName(firstName: 'Ada', lastName: ''), 'Ada');
  });

  test('joins first and last with a space', () {
    expect(
      formatMemberDisplayName(firstName: 'Ada', lastName: 'Lovelace'),
      'Ada Lovelace',
    );
  });
}
