import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/core/widgets/app_toast.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<void> showToast(
    WidgetTester tester, {
    String? actionLabel,
    VoidCallback? onAction,
  }) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => AppToast.show(
            context,
            message: 'Something went wrong',
            type: AppToastType.error,
            actionLabel: actionLabel,
            onAction: onAction,
          ),
          child: const Text('trigger'),
        ),
      ),
    );
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the message with an error icon', (tester) async {
    await showToast(tester);

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.byIcon(Icons.error_rounded), findsOneWidget);
  });

  testWidgets('runs the action when its label is tapped', (tester) async {
    var actions = 0;
    await showToast(tester, actionLabel: 'Retry', onAction: () => actions++);

    await tester.tap(find.text('Retry'));

    expect(actions, 1);
  });

  testWidgets('a new toast replaces the visible one', (tester) async {
    await showToast(tester);
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('a toast with an action auto-dismisses', (tester) async {
    await showToast(tester, actionLabel: 'Retry');
    expect(find.text('Something went wrong'), findsOneWidget);

    await tester.pump(AppMotion.toastDisplay + const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsNothing);
  });

  testWidgets('hide removes the visible toast', (tester) async {
    await showToast(tester);
    final context = tester.element(find.text('trigger'));

    AppToast.hide(context);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsNothing);
  });
}
