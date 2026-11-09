import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/legal_footer.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tapping each link calls its own callback', (tester) async {
    final taps = <String>[];
    await tester.pumpApp(
      LegalFooter(
        onTermsTap: () => taps.add('terms'),
        onPrivacyTap: () => taps.add('privacy'),
      ),
    );

    await tester.tapOnText(find.textRange.ofSubstring('Terms of Use'));
    await tester.tapOnText(find.textRange.ofSubstring('Privacy Policy'));

    expect(taps, ['terms', 'privacy']);
  });
}
