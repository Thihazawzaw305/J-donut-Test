import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_assets.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_shop.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_shop_card.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_shops_section.dart';

import '../../../../helpers/pump_app.dart';

const _shop = CatalogShop(
  id: 's_bo_aung_kyaw',
  nameKey: 'shopBoAungKyaw',
  addressKey: 'shopBoAungKyawAddress',
  imageAsset: 'assets/images/seed/shop_bo_aung_kyaw.jpg',
  sortOrder: 0,
);

void main() {
  testWidgets('shops block paints scenic background behind list', (
    tester,
  ) async {
    await tester.pumpApp(const HomeShopsSection(shops: [_shop]));
    await tester.pumpAndSettle();

    final image = tester.widget<Image>(
      find.descendant(
        of: find.byType(HomeShopsSection),
        matching: find.image(const AssetImage(AppAssets.homeShopsBackground)),
      ),
    );
    expect(image.fit, BoxFit.fitWidth);

    final sectionWidth = tester.getSize(find.byType(HomeShopsSection)).width;
    final background = tester.widget<SizedBox>(
      find.ancestor(
        of: find.image(const AssetImage(AppAssets.homeShopsBackground)),
        matching: find.byWidgetPredicate(
          (w) => w is SizedBox && w.height != null,
        ),
      ),
    );
    expect(
      background.height,
      sectionWidth *
          AppDimens.homeShopsBackgroundHeight /
          AppDimens.homeShopsBackgroundWidth,
    );

    expect(
      find.descendant(
        of: find.byType(HomeShopsSection),
        matching: find.image(const AssetImage(AppAssets.homeShopsGrassOverlay)),
      ),
      findsOneWidget,
    );
  });

  testWidgets('horizontal shop list keeps screen edge inset while scrolling', (
    tester,
  ) async {
    await tester.pumpApp(const HomeShopsSection(shops: [_shop]));
    await tester.pumpAndSettle();

    final scrollView = tester.widget<SingleChildScrollView>(
      find.descendant(
        of: find.byType(HomeShopsSection),
        matching: find.byWidgetPredicate(
          (w) =>
              w is SingleChildScrollView &&
              w.scrollDirection == Axis.horizontal,
        ),
      ),
    );
    expect(
      scrollView.padding,
      const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
    );
  });

  testWidgets('shop row height is not locked to a fixed viewport', (
    tester,
  ) async {
    await tester.pumpApp(const HomeShopsSection(shops: [_shop]));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(HomeShopsSection),
        matching: find.byWidgetPredicate(
          (w) => w is SizedBox && w.height != null && w.child is ListView,
        ),
      ),
      findsNothing,
    );

    final cardHeight = tester.getSize(find.byType(HomeShopCard)).height;
    final rowHeight = tester
        .getSize(
          find.descendant(
            of: find.byType(HomeShopsSection),
            matching: find.byType(Row),
          ),
        )
        .height;
    expect(rowHeight, cardHeight);
  });

  testWidgets('shop card in list matches intrinsic card height', (
    tester,
  ) async {
    await tester.pumpApp(const HomeShopCard(shop: _shop));
    await tester.pumpAndSettle();
    final aloneHeight = tester.getSize(find.byType(HomeShopCard)).height;

    await tester.pumpApp(const HomeShopsSection(shops: [_shop]));
    await tester.pumpAndSettle();
    final inListHeight = tester.getSize(find.byType(HomeShopCard)).height;

    expect(inListHeight, aloneHeight);
  });

  testWidgets('shop cards in row share equal height', (tester) async {
    const shops = [
      CatalogShop(
        id: 's_hledan',
        nameKey: 'shopHledan',
        addressKey: 'shopHledanAddress',
        imageAsset: 'assets/images/seed/shop_hledan.jpg',
        sortOrder: 0,
      ),
      CatalogShop(
        id: 's_bo_aung_kyaw',
        nameKey: 'shopBoAungKyaw',
        addressKey: 'shopBoAungKyawAddress',
        imageAsset: 'assets/images/seed/shop_bo_aung_kyaw.jpg',
        sortOrder: 1,
      ),
    ];

    await tester.pumpApp(const HomeShopsSection(shops: shops));
    await tester.pumpAndSettle();

    final cards = find.byType(HomeShopCard);
    expect(cards, findsNWidgets(2));

    final firstHeight = tester.getSize(cards.at(0)).height;
    final secondHeight = tester.getSize(cards.at(1)).height;
    expect(firstHeight, secondHeight);
  });
}
