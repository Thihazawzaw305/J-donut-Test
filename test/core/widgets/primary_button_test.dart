import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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

  group('semantics', () {
    SemanticsData dataOf(WidgetTester tester) =>
        tester.getSemantics(find.byType(PrimaryButton)).getSemanticsData();

    testWidgets('exposes a tap action when enabled and runs onPressed', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpApp(PrimaryButton(label: 'Go', onPressed: () => taps++));

      expect(dataOf(tester).hasAction(SemanticsAction.tap), isTrue);
      tester.semantics.tap(find.semantics.byLabel('Go'));

      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('has no tap action when disabled', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(const PrimaryButton(label: 'Go', onPressed: null));

      expect(dataOf(tester).hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('has no tap action and announces loading while loading', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        PrimaryButton(label: 'Go', onPressed: () {}, isLoading: true),
      );

      expect(dataOf(tester).hasAction(SemanticsAction.tap), isFalse);
      expect(dataOf(tester).value, 'Loading');
      handle.dispose();
    });
  });
}
