import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/catalog_assets.dart';
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/data/datasources/local/app_database.dart';
import 'package:j_donuts_app/features/catalog/data/seed/catalog_seed_bundle.dart';
import 'package:j_donuts_app/features/catalog/data/seed/catalog_seeder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reloadHomeCatalogFromDatabase completes and sections stay available',
      () async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWith((ref) async {
          final db = AppDatabase.memory();
          final json = await rootBundle.loadString(CatalogAssets.seedJson);
          final bundle = CatalogSeedBundle.fromJson(
            jsonDecode(json) as Map<String, dynamic>,
          );
          await seedCatalogIfEmpty(db, bundle);
          await syncCatalogStaticContentFromSeed(db, bundle);
          ref.onDispose(db.close);
          return db;
        }),
      ],
    );
    addTearDown(container.dispose);

    await container.read(databaseProvider.future);
    final sectionsSub = container.listen(catalogSectionsProvider, (_, _) {});
    addTearDown(sectionsSub.close);

    await container.read(catalogSectionsProvider.future);
    final before = container.read(catalogSectionsProvider).requireValue;

    final db = await container.read(databaseProvider.future);
    final bundle = await loadCatalogSeedBundle();
    await syncCatalogStaticContentFromSeed(db, bundle);
    container.invalidate(catalogSectionsProvider);

    await container.read(catalogSectionsProvider.future);
    final after = container.read(catalogSectionsProvider).requireValue;
    expect(after, isNotEmpty);
    expect(after.length, before.length);
  });
}
