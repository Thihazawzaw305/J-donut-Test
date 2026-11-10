import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/data/datasources/local/app_database.dart';
import 'package:j_donuts_app/features/catalog/data/seed/catalog_seed_bundle.dart';
import 'package:j_donuts_app/features/catalog/data/seed/catalog_seeder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('seeder runs once and is idempotent', () async {
    final json = await rootBundle.loadString('assets/seed/catalog_v1.json');
    final bundle = CatalogSeedBundle.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
    final db = AppDatabase.memory();

    await seedCatalogIfEmpty(db, bundle);
    await seedCatalogIfEmpty(db, bundle);

    final count = await db.customSelect(
      'SELECT COUNT(*) AS c FROM product_rows',
    ).getSingle();
    expect(count.data['c'], bundle.products.length);

    await db.close();
  });

  test('syncBannersFromSeed updates banner assets from bundle', () async {
    final json = await rootBundle.loadString('assets/seed/catalog_v1.json');
    final bundle = CatalogSeedBundle.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
    final db = AppDatabase.memory();

    await seedCatalogIfEmpty(db, bundle);
    await syncBannersFromSeed(db, bundle);

    final rows = await db.select(db.bannerRows).get();
    expect(rows.length, bundle.banners.length);
    final assets = rows.map((r) => r.imageAsset).toSet();
    expect(
      assets,
      bundle.banners.map((b) => b.imageAsset).toSet(),
    );

    await db.close();
  });

  test('syncShopsFromSeed updates shop assets from bundle', () async {
    final json = await rootBundle.loadString('assets/seed/catalog_v1.json');
    final bundle = CatalogSeedBundle.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
    final db = AppDatabase.memory();

    await seedCatalogIfEmpty(db, bundle);
    await syncShopsFromSeed(db, bundle);

    final rows = await db.select(db.shopRows).get();
    expect(rows.length, bundle.shops.length);
    final assets = rows.map((r) => r.imageAsset).toSet();
    expect(assets, bundle.shops.map((s) => s.imageAsset).toSet());
    expect(assets.every((path) => path.endsWith('.jpg')), isTrue);

    await db.close();
  });
}
