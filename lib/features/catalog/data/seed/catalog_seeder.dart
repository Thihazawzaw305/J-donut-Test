import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/catalog_assets.dart';
import '../datasources/local/app_database.dart';
import 'catalog_seed_bundle.dart';

Future<CatalogSeedBundle> loadCatalogSeedBundle() async {
  final json = await rootBundle.loadString(CatalogAssets.seedJson);
  return CatalogSeedBundle.fromJson(jsonDecode(json) as Map<String, dynamic>);
}

Future<void> syncCatalogStaticContentFromSeed(
  AppDatabase db,
  CatalogSeedBundle bundle,
) async {
  await syncBannersFromSeed(db, bundle);
  await syncShopsFromSeed(db, bundle);
}

Future<void> seedCatalogIfEmpty(
  AppDatabase db,
  CatalogSeedBundle bundle,
) async {
  if (await db.hasProducts()) return;

  await db.transaction(() async {
    await db.delete(db.memberRows).go();
    await db.delete(db.productRows).go();
    await db.delete(db.bannerRows).go();
    await db.delete(db.sectionRows).go();
    await db.delete(db.sectionProductRows).go();
    await db.delete(db.shopRows).go();

    final m = bundle.member;
    await db.into(db.memberRows).insert(
      MemberRowsCompanion.insert(
        id: 'default',
        displayName: m.displayName,
        subtitleKey: m.subtitleKey,
        avatarAsset: m.avatarAsset,
        tierProgressKey: m.tierProgressKey,
        tierProgressKyats: m.tierProgressKyats,
        notificationCount: m.notificationCount,
        tierCode: m.tierCode,
        pointsBalance: m.pointsBalance,
        pointsToNextTier: m.pointsToNextTier,
      ),
    );

    for (final p in bundle.products) {
      await db.into(db.productRows).insert(
        ProductRowsCompanion.insert(
          id: p.id,
          code: p.code,
          nameKey: p.nameKey,
          priceMmk: p.priceMmk,
          isNew: p.isNew,
          discountPercent: Value(p.discountPercent),
          imageAsset: p.imageAsset,
          imageUrl: Value(p.imageUrl),
          descriptionKey: p.descriptionKey,
        ),
      );
    }

    for (final b in bundle.banners) {
      await db.into(db.bannerRows).insert(
        BannerRowsCompanion.insert(
          id: b.id,
          imageAsset: b.imageAsset,
          sortOrder: b.sortOrder,
        ),
      );
    }

    for (var i = 0; i < bundle.sections.length; i++) {
      final s = bundle.sections[i];
      await db.into(db.sectionRows).insert(
        SectionRowsCompanion.insert(
          id: s.id,
          titleKey: s.titleKey,
          cardStyle: s.cardStyle.name,
          sortOrder: i,
        ),
      );
      for (var j = 0; j < s.productIds.length; j++) {
        await db.into(db.sectionProductRows).insert(
          SectionProductRowsCompanion.insert(
            sectionId: s.id,
            productId: s.productIds[j],
            sortIndex: j,
          ),
        );
      }
    }

    for (final shop in bundle.shops) {
      await db.into(db.shopRows).insert(
        ShopRowsCompanion.insert(
          id: shop.id,
          nameKey: shop.nameKey,
          addressKey: shop.addressKey,
          imageAsset: shop.imageAsset,
          sortOrder: shop.sortOrder,
        ),
      );
    }
  });
}

/// Replaces banner rows from bundled seed when catalog already exists.
Future<void> syncShopsFromSeed(
  AppDatabase db,
  CatalogSeedBundle bundle,
) async {
  await db.transaction(() async {
    await db.delete(db.shopRows).go();
    for (final shop in bundle.shops) {
      await db.into(db.shopRows).insert(
        ShopRowsCompanion.insert(
          id: shop.id,
          nameKey: shop.nameKey,
          addressKey: shop.addressKey,
          imageAsset: shop.imageAsset,
          sortOrder: shop.sortOrder,
        ),
      );
    }
  });
}

Future<void> syncBannersFromSeed(
  AppDatabase db,
  CatalogSeedBundle bundle,
) async {
  await db.transaction(() async {
    await db.delete(db.bannerRows).go();
    for (final b in bundle.banners) {
      await db.into(db.bannerRows).insert(
        BannerRowsCompanion.insert(
          id: b.id,
          imageAsset: b.imageAsset,
          sortOrder: b.sortOrder,
        ),
      );
    }
  });
}
