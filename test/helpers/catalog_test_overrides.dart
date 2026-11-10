import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/core/constants/catalog_assets.dart';
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/data/datasources/local/app_database.dart';
import 'package:j_donuts_app/features/catalog/data/seed/catalog_seed_bundle.dart';
import 'package:j_donuts_app/features/catalog/data/seed/catalog_seeder.dart';

Override catalogDatabaseOverride() {
  return databaseProvider.overrideWith((ref) async {
    final db = AppDatabase.memory();
    final json = await rootBundle.loadString(CatalogAssets.seedJson);
    final bundle = CatalogSeedBundle.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
    await seedCatalogIfEmpty(db, bundle);
    if (await db.hasProducts()) {
      await syncBannersFromSeed(db, bundle);
    }
    ref.onDispose(db.close);
    return db;
  });
}

Future<void> tearDownCatalog(WidgetTester tester) async {
  if (find.byType(JDonutsApp).evaluate().isEmpty) return;
  final container = ProviderScope.containerOf(
    tester.element(find.byType(JDonutsApp)),
  );
  container.invalidate(databaseProvider);
  await tester.pump();
}
