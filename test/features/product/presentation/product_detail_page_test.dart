import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/product/presentation/pages/product_detail_page.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

import '../../../helpers/catalog_test_overrides.dart';

Future<void> _pumpDetail(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(child);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _tapIncrease(WidgetTester tester) async {
  final button = find.byTooltip('Increase quantity');
  await tester.tapAt(tester.getRect(button).center);
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('quantity starts at one and decrease is a no-op at minimum', (
    tester,
  ) async {
    await _pumpDetail(
      tester,
      ProviderScope(
        overrides: [catalogDatabaseOverride()],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProductDetailPage(productId: 'p_jbites_chocolate'),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('ADD TO CART'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await _tapIncrease(tester);
    expect(find.text('2'), findsOneWidget);

    await tester.pump(AppMotion.medium);
    expect(find.text('ADD TO CART'), findsOneWidget);
    expect(find.text('2,400 MMK'), findsOneWidget);
  });

  testWidgets('add to cart footer stays visible at minimum quantity', (
    tester,
  ) async {
    const overrideProduct = CatalogProduct(
      id: 'p_coconut',
      code: 'JD022123',
      nameKey: 'productCoconutDonut',
      priceMmk: 3200,
      isNew: false,
      discountPercent: null,
      imageAsset: 'assets/images/seed/p_coconut.png',
      imageUrl: null,
      descriptionKey: 'productCoconutDescription',
    );

    await _pumpDetail(
      tester,
      ProviderScope(
        overrides: [
          productByIdProvider(
            'p_coconut',
          ).overrideWith((ref) async => overrideProduct),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProductDetailPage(productId: 'p_coconut'),
        ),
      ),
    );

    expect(find.text('ADD TO CART'), findsOneWidget);

    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pump();
    await tester.pumpAndSettle(AppMotion.medium);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('ADD TO CART'), findsOneWidget);
    expect(find.text('3,200 MMK'), findsWidgets);
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
          productByIdProvider(
            'p_coconut',
          ).overrideWith((ref) async => overrideProduct),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProductDetailPage(productId: 'p_coconut'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('9,999 MMK'), findsWidgets);
  });

  testWidgets('favorite control is present', (tester) async {
    const overrideProduct = CatalogProduct(
      id: 'p_coconut',
      code: 'JD022123',
      nameKey: 'productCoconutDonut',
      priceMmk: 3200,
      isNew: true,
      discountPercent: null,
      imageAsset: 'assets/images/seed/p_coconut.png',
      imageUrl: null,
      descriptionKey: 'productCoconutDescription',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productByIdProvider(
            'p_coconut',
          ).overrideWith((ref) async => overrideProduct),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProductDetailPage(productId: 'p_coconut'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
