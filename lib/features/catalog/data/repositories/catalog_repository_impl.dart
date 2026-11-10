import 'package:drift/drift.dart';

import '../../domain/entities/catalog_banner.dart';
import '../../domain/entities/catalog_member.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/entities/catalog_section.dart';
import '../../domain/entities/catalog_shop.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/local/app_database.dart';
import '../mappers/catalog_row_mappers.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<CatalogMember?> watchMember() {
    return (_db.select(_db.memberRows)..limit(1)).watch().map((rows) {
      if (rows.isEmpty) return null;
      return mapMemberRow(rows.first);
    });
  }

  @override
  Stream<List<CatalogBanner>> watchBanners() {
    final q = _db.select(_db.bannerRows)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return q.watch().map((rows) => rows.map(mapBannerRow).toList());
  }

  @override
  Stream<List<CatalogSection>> watchSections() {
    final sectionsQ = _db.select(_db.sectionRows)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return sectionsQ.watch().asyncMap(_mapSections);
  }

  Future<List<CatalogSection>> _mapSections(List<SectionRow> sections) async {
    final out = <CatalogSection>[];
    for (final section in sections) {
      final links = await (_db.select(_db.sectionProductRows)
            ..where((t) => t.sectionId.equals(section.id))
            ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]))
          .get();
      final ids = links.map((e) => e.productId).toList();
      final products = ids.isEmpty
          ? <CatalogProduct>[]
          : await (_db.select(_db.productRows)
                ..where((t) => t.id.isIn(ids)))
              .get()
              .then((rows) {
                final byId = {for (final r in rows) r.id: mapProductRow(r)};
                return [for (final id in ids) if (byId[id] != null) byId[id]!];
              });
      out.add(
        CatalogSection(
          id: section.id,
          titleKey: section.titleKey,
          cardStyle: mapCardStyle(section.cardStyle),
          productIds: ids,
          products: products,
        ),
      );
    }
    return out;
  }

  @override
  Stream<List<CatalogShop>> watchShops() {
    final q = _db.select(_db.shopRows)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return q.watch().map((rows) => rows.map(mapShopRow).toList());
  }

  @override
  Future<CatalogProduct?> productById(String id) async {
    final row = await (_db.select(_db.productRows)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : mapProductRow(row);
  }
}
