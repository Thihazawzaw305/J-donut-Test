import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/product/presentation/widgets/product_detail_hero_card.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

ProductDetailHeroCard _card({bool showNewBadge = false, int quantity = 1}) =>
    ProductDetailHeroCard(
      productId: 'p_coconut',
      productCode: 'JD022123',
      name: 'Coconut Donut',
      unitPriceLabel: '3,200 MMK',
      imageAsset: 'assets/images/seed/p_coconut.png',
      imageUrl: null,
      showNewBadge: showNewBadge,
      newBadgeLabel: 'New',
      quantity: quantity,
      onDecrease: () {},
      onIncrease: () {},
    );

void main() {
  testWidgets('shows product code', (tester) async {
    await tester.pumpWidget(_wrap(_card()));

    expect(find.text('JD022123'), findsOneWidget);
  });

  testWidgets('product image uses fixed width and height', (tester) async {
    await tester.pumpWidget(_wrap(_card()));

    final imageSlot = find.descendant(
      of: find.byType(ProductDetailHeroCard),
      matching: find.byType(SizedBox),
    );
    expect(imageSlot, findsWidgets);

    final sizedBox = find.descendant(
      of: find.byType(ProductDetailHeroCard),
      matching: find.byWidgetPredicate(
        (w) =>
            w is SizedBox &&
            w.width == AppDimens.productDetailImageWidth &&
            w.height == AppDimens.productDetailImageHeight,
      ),
    );
    final size = tester.getSize(sizedBox);
    expect(size.width, AppDimens.productDetailImageWidth);
    expect(size.height, AppDimens.productDetailImageHeight);
  });

  testWidgets('shows New badge when showNewBadge is true', (tester) async {
    await tester.pumpWidget(_wrap(_card(showNewBadge: true)));

    expect(find.text('New'), findsOneWidget);
  });

  testWidgets('hides New badge when showNewBadge is false', (tester) async {
    await tester.pumpWidget(_wrap(_card()));

    expect(find.text('New'), findsNothing);
  });

  testWidgets('does not show discount percent badge', (tester) async {
    await tester.pumpWidget(_wrap(_card()));

    expect(find.textContaining('-%'), findsNothing);
  });

  testWidgets('stepper sits in stack overlapping card', (tester) async {
    await tester.pumpWidget(_wrap(_card(quantity: 2)));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(ProductDetailHeroCard),
        matching: find.byType(Stack),
      ),
      findsWidgets,
    );
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('increase responds when tap is on lower stepper hit target', (
    tester,
  ) async {
    var quantity = 0;
    void onIncrease() => quantity++;

    await tester.pumpWidget(
      _wrap(
        ProductDetailHeroCard(
          productId: 'p_coconut',
          productCode: 'JD022123',
          name: 'Coconut Donut',
          unitPriceLabel: '3,200 MMK',
          imageAsset: 'assets/images/seed/p_coconut.png',
          imageUrl: null,
          showNewBadge: false,
          newBadgeLabel: 'New',
          quantity: quantity,
          onDecrease: () {},
          onIncrease: onIncrease,
        ),
      ),
    );

    final increase = find.byTooltip('Increase quantity');
    final rect = tester.getRect(increase);
    await tester.tapAt(rect.bottomCenter - const Offset(0, 4));
    await tester.pump();

    expect(quantity, 1);
  });
}
