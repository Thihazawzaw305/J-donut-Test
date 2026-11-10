import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/core/theme/app_text_styles.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_shop.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_shop_card.dart';

import '../../../../helpers/pump_app.dart';

const _shop = CatalogShop(
  id: 's_bo_aung_kyaw',
  nameKey: 'shopBoAungKyaw',
  addressKey: 'shopBoAungKyawAddress',
  imageAsset: 'assets/images/seed/shop_bo_aung_kyaw.jpg',
  sortOrder: 0,
);

void main() {
  testWidgets('uses mock-style white card with image, copy, and link', (
    tester,
  ) async {
    await tester.pumpApp(const HomeShopCard(shop: _shop));
    await tester.pumpAndSettle();

    final card = find.descendant(
      of: find.byType(HomeShopCard),
      matching: find.byWidgetPredicate(
        (w) => w is SizedBox && w.width == AppDimens.homeShopCardWidth,
      ),
    );
    expect(tester.getSize(card).width, AppDimens.homeShopCardWidth);

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(HomeShopCard),
        matching: find.byType(Material),
      ),
    );
    expect(material.elevation, 3);
    expect(
      material.borderRadius,
      BorderRadius.circular(AppDimens.homeShopCardRadius),
    );
    expect(material.clipBehavior, Clip.none);

    final imageBox = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(HomeShopCard),
        matching: find.byWidgetPredicate(
          (w) => w is SizedBox && w.height == AppDimens.homeShopCardImageHeight,
        ),
      ),
    );
    expect(imageBox.height, AppDimens.homeShopCardImageHeight);

    final clipRRect = tester.widget<ClipRRect>(
      find.descendant(
        of: find.byType(HomeShopCard),
        matching: find.byType(ClipRRect),
      ),
    );
    expect(
      clipRRect.borderRadius,
      BorderRadius.circular(AppDimens.homeShopCardImageRadius),
    );

    final inset = tester.widget<Padding>(
      find
          .descendant(
            of: find.byType(Material),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Padding &&
                  w.padding == const EdgeInsets.all(AppDimens.spaceMd),
            ),
          )
          .first,
    );
    expect(inset.padding, const EdgeInsets.all(AppDimens.spaceMd));

    final name = tester.widget<Text>(find.text('Bo Aung Kyaw'));
    expect(name.style?.fontSize, AppTextStyles.homeShopCardTitle.fontSize);

    expect(find.text('Order online'), findsOneWidget);
  });
}
