import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/core/theme/app_text_styles.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/otp_resend_row.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('resend copy is two lines with only the time in pink', (
    tester,
  ) async {
    await tester.pumpApp(OtpResendRow(remainingSeconds: 112, onResend: () {}));

    expect(find.text("Didn't receive the code?"), findsOneWidget);
    expect(
      find.text('resend in 1 : 52 min', findRichText: true),
      findsOneWidget,
    );

    final rich = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText() == 'resend in 1 : 52 min',
      ),
    );
    final time = _spanWithText(rich.text, '1 : 52');
    expect(time, isNotNull);
    expect(time!.style?.color, AppColors.accent);
    expect(time.style?.fontWeight, AppTextStyles.link.fontWeight);
  });
}

TextSpan? _spanWithText(InlineSpan span, String text) {
  if (span is TextSpan) {
    if (span.text == text) return span;
    for (final child in span.children ?? const <InlineSpan>[]) {
      final match = _spanWithText(child, text);
      if (match != null) return match;
    }
  }
  return null;
}
