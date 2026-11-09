import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/otp_boxes.dart';

void main() {
  testWidgets('empty focused box paints a cyan cursor', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: OtpDigitBox(digit: '', showCursor: true)),
      ),
    );

    final cursor = tester.widget<Container>(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == AppColors.otpCursor,
      ),
    );
    expect(cursor.color, AppColors.primary);
  });
}
