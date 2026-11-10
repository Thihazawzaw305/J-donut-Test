import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_banner.dart';
import 'package:j_donuts_app/features/catalog/presentation/widgets/catalog_image.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_banner_carousel.dart';

import '../../../../helpers/pump_app.dart';

const _banners = [
  CatalogBanner(
    id: 'a',
    imageAsset: 'assets/images/seed/banner_promo_one.jpg',
    sortOrder: 0,
  ),
  CatalogBanner(
    id: 'b',
    imageAsset: 'assets/images/seed/banner_promo_two.jpg',
    sortOrder: 1,
  ),
];

String visibleBannerAsset(WidgetTester tester) {
  final image = tester.widget<CatalogImage>(find.byType(CatalogImage).first);
  return image.asset;
}

void main() {
  testWidgets('banner slides have horizontal padding only', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpApp(const HomeBannerCarousel(banners: _banners));
    await tester.pumpAndSettle();

    final slidePadding = find.ancestor(
      of: find.byType(ClipRRect).first,
      matching: find.byType(Padding),
    );
    expect(slidePadding, findsOneWidget);
    final insets = tester.widget<Padding>(slidePadding).padding as EdgeInsets;
    expect(insets.left, AppDimens.homeBannerItemPaddingH);
    expect(insets.right, AppDimens.homeBannerItemPaddingH);
    expect(insets.top, 0);
    expect(insets.bottom, 0);
  });

  testWidgets('auto-advances after carousel interval', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpApp(const HomeBannerCarousel(banners: _banners));
    await tester.pumpAndSettle();

    final before = visibleBannerAsset(tester);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(visibleBannerAsset(tester), isNot(before));
  });

  testWidgets('wraps infinitely when user swipes', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpApp(const HomeBannerCarousel(banners: _banners));
    await tester.pumpAndSettle();

    final before = visibleBannerAsset(tester);
    await tester.drag(find.byType(HomeBannerCarousel), const Offset(-320, 0));
    await tester.pumpAndSettle();
    final afterFirstSwipe = visibleBannerAsset(tester);
    expect(afterFirstSwipe, isNot(before));

    await tester.drag(find.byType(HomeBannerCarousel), const Offset(-320, 0));
    await tester.pumpAndSettle();
    expect(visibleBannerAsset(tester), before);
  });
}
