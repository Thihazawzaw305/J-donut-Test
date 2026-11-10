import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/core/theme/app_text_styles.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_section.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/product_card_style.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_product_section.dart';

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

CatalogSection _section({
  String id = 'popular',
  String titleKey = 'homeSectionPopular',
  ProductCardStyle cardStyle = ProductCardStyle.mediumRect,
}) =>
    CatalogSection(
      id: id,
      titleKey: titleKey,
      cardStyle: cardStyle,
      productIds: const ['prod-1'],
      products: const [_sampleProduct],
    );

void main() {
  testWidgets('uses compact section title and white see-all control', (
    tester,
  ) async {
    await tester.pumpApp(HomeProductSection(section: _section()));
    await tester.pumpAndSettle();

    final title = tester.widget<Text>(find.text('Popular 🔥'));
    expect(title.style?.fontSize, AppDimens.homeSectionTitleSize);
    expect(title.style?.fontWeight, AppTextStyles.homeSectionTitle.fontWeight);

    final icon = find.byIcon(Icons.chevron_right);
    expect(tester.widget<Icon>(icon).size, AppDimens.homeSeeAllIconSize);

    final seeAllMaterial = tester.widget<Material>(
      find.ancestor(of: icon, matching: find.byType(Material)).first,
    );
    expect(seeAllMaterial.color, AppColors.surface);

    final circle = tester.widget<SizedBox>(
      find.ancestor(
        of: icon,
        matching: find.byWidgetPredicate(
          (w) =>
              w is SizedBox && w.width == AppDimens.homeSeeAllButtonSize,
        ),
      ),
    );
    expect(circle.height, AppDimens.homeSeeAllButtonSize);
  });

  testWidgets('seasonal section uses extra top gap before horizontal list', (
    tester,
  ) async {
    await tester.pumpApp(
      HomeProductSection(
        section: _section(
          id: 'seasonal',
          titleKey: 'homeSectionSeasonal',
          cardStyle: ProductCardStyle.largeRect,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final row = find.descendant(
      of: find.byType(HomeProductSection),
      matching: find.byType(Row),
    );
    final listView = find.descendant(
      of: find.byType(HomeProductSection),
      matching: find.byType(ListView),
    );
    final gap =
        tester.getTopLeft(listView).dy - tester.getBottomLeft(row).dy;
    expect(gap, AppDimens.homeSeasonalListTopGap);
  });

  testWidgets('non-seasonal section keeps default top gap before list', (
    tester,
  ) async {
    await tester.pumpApp(HomeProductSection(section: _section()));
    await tester.pumpAndSettle();

    final row = find.descendant(
      of: find.byType(HomeProductSection),
      matching: find.byType(Row),
    );
    final listView = find.descendant(
      of: find.byType(HomeProductSection),
      matching: find.byType(ListView),
    );
    final gap =
        tester.getTopLeft(listView).dy - tester.getBottomLeft(row).dy;
    expect(gap, AppDimens.spaceMd);
  });

  testWidgets('empty section shows inline empty message', (tester) async {
    await tester.pumpApp(
      const HomeProductSection(
        section: CatalogSection(
          id: 'popular',
          titleKey: 'homeSectionPopular',
          cardStyle: ProductCardStyle.mediumRect,
          productIds: [],
          products: [],
        ),
      ),
    );

    expect(find.text('Nothing here right now.'), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('error section shows retry action', (tester) async {
    var retried = false;
    await tester.pumpApp(
      HomeProductSection(
        section: _section(),
        errorMessage: 'Could not load this section.',
        onRetry: () => retried = true,
      ),
    );

    expect(find.text('Could not load this section.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retried, isTrue);
  });

  testWidgets('seasonal section has extra top padding above title row', (
    tester,
  ) async {
    await tester.pumpApp(
      HomeProductSection(
        section: _section(
          id: 'seasonal',
          titleKey: 'homeSectionSeasonal',
          cardStyle: ProductCardStyle.largeRect,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final outer = find.byWidgetPredicate(
      (w) =>
          w is Padding &&
          (w.padding as EdgeInsets).bottom == AppDimens.spaceLg &&
          w.child is Column,
    );
    expect(
      (tester.widget<Padding>(outer).padding as EdgeInsets).top,
      AppDimens.homeSeasonalSectionTopPadding,
    );
  });
}
