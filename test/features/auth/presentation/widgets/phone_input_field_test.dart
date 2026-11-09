import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/phone_input_field.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });

  tearDown(() {
    controller.dispose();
    focusNode.dispose();
  });

  Future<void> pumpField(WidgetTester tester) => tester.pumpApp(
        PhoneInputField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (_) {},
          onSubmitted: (_) {},
        ),
      );

  testWidgets('shows the +95 country code prefix', (tester) async {
    await pumpField(tester);

    expect(find.text('+95'), findsOneWidget);
  });

  testWidgets('keeps only digits, spaces and dashes', (tester) async {
    await pumpField(tester);

    await tester.enterText(find.byType(TextField), 'a9-25 4x');

    expect(controller.text, '9-25 4');
  });

  testWidgets('loses focus when the user taps outside', (tester) async {
    await pumpField(tester);
    await tester.tap(find.byType(TextField));
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(5, 500));

    expect(focusNode.hasFocus, isFalse);
  });
}
