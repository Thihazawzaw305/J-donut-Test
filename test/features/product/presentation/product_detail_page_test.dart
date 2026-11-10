import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:j_donuts_app/features/product/presentation/pages/product_detail_page.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

import '../../../helpers/catalog_test_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('quantity stepper enforces minimum of one', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [catalogDatabaseOverride()],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProductDetailPage(productId: 'p_jbites_chocolate'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('2,400 Ks'), findsOneWidget);
  });

  testWidgets('unit price reflects product entity priceMmk', (tester) async {
    const overrideProduct = CatalogProduct(
      id: 'p_coconut',
      code: 'JD022123',
      nameKey: 'productCoconutDonut',
      priceMmk: 9999,
      isNew: false,
      discountPercent: null,
      imageAsset: 'assets/images/seed/p_coconut.png',
      imageUrl: null,
      descriptionKey: 'productCoconutDescription',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productByIdProvider('p_coconut').overrideWith(
            (ref) async => overrideProduct,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProductDetailPage(productId: 'p_coconut'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('9,999 Ks'), findsWidgets);
  });
}
