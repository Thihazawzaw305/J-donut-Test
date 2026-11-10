import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/catalog/data/datasources/local/app_database.dart';
import '../../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../../features/catalog/data/seed/catalog_seeder.dart';
import '../../features/catalog/domain/entities/catalog_banner.dart';
import '../../features/catalog/domain/entities/catalog_challenge.dart';
import '../../features/catalog/domain/entities/catalog_member.dart';
import '../../features/catalog/domain/entities/catalog_product.dart';
import '../../features/catalog/domain/entities/catalog_section.dart';
import '../../features/catalog/domain/entities/catalog_shop.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final db = await openAppDatabase();
  final bundle = await loadCatalogSeedBundle();
  await seedCatalogIfEmpty(db, bundle);
  await syncCatalogStaticContentFromSeed(db, bundle);
  ref.onDispose(db.close);
  return db;
});

/// Syncs seed assets into SQLite, then re-subscribes catalog streams from the DB.
Future<void> reloadHomeCatalogFromDatabase(WidgetRef ref) async {
  final db = await ref.read(databaseProvider.future);
  final bundle = await loadCatalogSeedBundle();
  await syncCatalogStaticContentFromSeed(db, bundle);

  ref
    ..invalidate(catalogMemberProvider)
    ..invalidate(catalogBannersProvider)
    ..invalidate(catalogSectionsProvider)
    ..invalidate(catalogShopsProvider)
    ..invalidate(catalogChallengesProvider);

  await Future.wait([
    ref.read(catalogMemberProvider.future),
    ref.read(catalogBannersProvider.future),
    ref.read(catalogSectionsProvider.future),
    ref.read(catalogShopsProvider.future),
    ref.read(catalogChallengesProvider.future),
  ]);
}

/// Re-applies bundled seed and reloads home catalog streams (pull-to-refresh).
Future<void> refreshCatalogFromSeed(WidgetRef ref) =>
    reloadHomeCatalogFromDatabase(ref);

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final db = ref.watch(databaseProvider).requireValue;
  return CatalogRepositoryImpl(db);
});

final catalogMemberProvider = StreamProvider<CatalogMember?>((ref) {
  final db = ref.watch(databaseProvider);
  if (!db.hasValue) return const Stream.empty();
  return ref.watch(catalogRepositoryProvider).watchMember();
});

final catalogBannersProvider = StreamProvider<List<CatalogBanner>>((ref) {
  final db = ref.watch(databaseProvider);
  if (!db.hasValue) return const Stream.empty();
  return ref.watch(catalogRepositoryProvider).watchBanners();
});

final catalogSectionsProvider = StreamProvider<List<CatalogSection>>((ref) {
  final db = ref.watch(databaseProvider);
  if (!db.hasValue) return const Stream.empty();
  return ref.watch(catalogRepositoryProvider).watchSections();
});

final catalogShopsProvider = StreamProvider<List<CatalogShop>>((ref) {
  final db = ref.watch(databaseProvider);
  if (!db.hasValue) return const Stream.empty();
  return ref.watch(catalogRepositoryProvider).watchShops();
});

final catalogChallengesProvider = StreamProvider<List<CatalogChallenge>>((ref) {
  final db = ref.watch(databaseProvider);
  if (!db.hasValue) return const Stream.empty();
  return ref.watch(catalogRepositoryProvider).watchChallenges();
});

final productByIdProvider = FutureProvider.family<CatalogProduct?, String>((
  ref,
  id,
) async {
  await ref.watch(databaseProvider.future);
  return ref.watch(catalogRepositoryProvider).productById(id);
});
