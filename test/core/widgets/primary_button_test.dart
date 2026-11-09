import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the label in upper case', (tester) async {
    await tester.pumpApp(PrimaryButton(label: 'Continue', onPressed: () {}));

    expect(find.text('CONTINUE'), findsOneWidget);
  });

  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await tester.pumpApp(PrimaryButton(label: 'Go', onPressed: () => taps++));

    await tester.tap(find.byType(PrimaryButton));

    expect(taps, 1);
  });

  testWidgets('shows a spinner and ignores taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      PrimaryButton(label: 'Go', onPressed: () => taps++, isLoading: true),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byType(PrimaryButton));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('GO'), findsNothing);
    expect(taps, 0);
  });
}
