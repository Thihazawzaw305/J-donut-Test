import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/product_card_style.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_product_tile.dart';

import '../../../../helpers/pump_app.dart';

const _sampleProduct = CatalogProduct(
  id: 'prod-1',
  code: 'D001',
  nameKey: 'productNameGlaze',
  priceMmk: 1500,
  isNew: false,
  discountPercent: null,
  imageAsset: 'assets/seed/products/glaze.png',
  imageUrl: null,
  descriptionKey: 'productDescGlaze',
);

void expectMediumFeaturedTile(WidgetTester tester) {
  final tileSize = tester.getSize(find.byType(HomeProductTile));
  expect(tileSize.width, AppDimens.homeProductPopularWidth);
  expect(tileSize.width, greaterThan(AppDimens.homeProductMediumWidth));

  final imageBox = tester.widget<SizedBox>(
    find.descendant(
      of: find.byType(HomeProductTile),
      matching: find.byWidgetPredicate(
        (w) => w is SizedBox && w.height == AppDimens.homeProductPopularHeight,
      ),
    ),
  );
  expect(imageBox.width, AppDimens.homeProductPopularWidth);

  final cardMaterial = tester.widget<Material>(
    find.descendant(
      of: find.byType(HomeProductTile),
      matching: find.byWidgetPredicate(
        (w) =>
            w is Material &&
            w.borderRadius != null &&
            w.borderRadius != BorderRadius.zero,
      ),
    ),
  );
  expect(
    cardMaterial.borderRadius,
    BorderRadius.circular(AppDimens.homeProductPopularCardRadius),
  );
  expect(
    AppDimens.homeProductPopularCardRadius,
    lessThan(AppDimens.homeCardRadius),
  );
}

void main() {
  testWidgets('largeRect tile is wider with smaller image radius', (
    tester,
  ) async {
    await tester.pumpApp(
      const HomeProductTile(
        product: _sampleProduct,
        cardStyle: ProductCardStyle.largeRect,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(HomeProductTile)).width,
      AppDimens.homeProductLargeWidth,
    );

    final cardMaterial = tester.widget<Material>(
      find.descendant(
        of: find.byType(HomeProductTile),
        matching: find.byWidgetPredicate(
          (w) =>
              w is Material &&
              w.borderRadius != null &&
              w.borderRadius != BorderRadius.zero,
        ),
      ),
    );
    expect(
      cardMaterial.borderRadius,
      BorderRadius.circular(AppDimens.homeProductLargeCardRadius),
    );
  });

  testWidgets('popular section tile is slightly wider and taller than medium', (
    tester,
  ) async {
    await tester.pumpApp(
      const HomeProductTile(
        product: _sampleProduct,
        cardStyle: ProductCardStyle.mediumRect,
        sectionId: 'popular',
      ),
    );
    await tester.pumpAndSettle();
    expectMediumFeaturedTile(tester);
  });

  testWidgets('square tile uses same corner radius as featured rows', (
    tester,
  ) async {
    await tester.pumpApp(
      const HomeProductTile(
        product: _sampleProduct,
        cardStyle: ProductCardStyle.square,
      ),
    );
    await tester.pumpAndSettle();

    final cardMaterial = tester.widget<Material>(
      find.descendant(
        of: find.byType(HomeProductTile),
        matching: find.byWidgetPredicate(
          (w) =>
              w is Material &&
              w.borderRadius != null &&
              w.borderRadius != BorderRadius.zero,
        ),
      ),
    );
    expect(
      cardMaterial.borderRadius,
      BorderRadius.circular(AppDimens.homeProductSquareCardRadius),
    );
    expect(
      AppDimens.homeProductSquareCardRadius,
      AppDimens.homeProductPopularCardRadius,
    );
  });

  testWidgets('order again section matches popular card layout', (
    tester,
  ) async {
    await tester.pumpApp(
      const HomeProductTile(
        product: _sampleProduct,
        cardStyle: ProductCardStyle.mediumRect,
        sectionId: 'orderAgain',
      ),
    );
    await tester.pumpAndSettle();
    expectMediumFeaturedTile(tester);
  });
}
