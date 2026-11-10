import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_assets.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_shop.dart';
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
    expect(find.byType(ClipRRect), findsNothing);
  });
}
