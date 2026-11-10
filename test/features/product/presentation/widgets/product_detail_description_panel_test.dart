import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/product/presentation/widgets/product_detail_description_panel.dart';

void main() {
  testWidgets('whats this and description share horizontal row', (tester) async {
    const panel = ProductDetailDescriptionPanel(
      whatsThisLabel: "What's this?",
      description: 'Soft sweet donuts.',
    );

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: panel)),
    );

    final whatsThis = find.text("What's this?");
    final body = find.text('Soft sweet donuts.');
    expect(whatsThis, findsOneWidget);
    expect(body, findsOneWidget);

    final rowFinder = find.ancestor(
      of: whatsThis,
      matching: find.byType(Row),
    );
    expect(rowFinder, findsWidgets);
    expect(
      find.descendant(of: rowFinder.first, matching: body),
      findsOneWidget,
    );
  });
}
