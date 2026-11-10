import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> selectBirthdayInTest(WidgetTester tester, DateTime date) async {
  final chrome = tester.getRect(
    find.ancestor(of: find.text('Day'), matching: find.byType(Container)).first,
  );
  await tester.tapAt(chrome.topLeft + const Offset(8, 8));
  await tester.pumpAndSettle();
  tester
      .widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker))
      .onDateTimeChanged(date);
  await tester.pump();
  await tester.tap(find.text('SELECT'));
  await tester.pumpAndSettle();
}
