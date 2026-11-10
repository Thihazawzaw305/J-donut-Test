import '../entities/catalog_banner.dart';
import '../entities/catalog_member.dart';
import '../entities/catalog_product.dart';
import '../entities/catalog_section.dart';
import '../entities/catalog_shop.dart';

abstract interface class CatalogRepository {
  Stream<CatalogMember?> watchMember();

  Stream<List<CatalogBanner>> watchBanners();

  Stream<List<CatalogSection>> watchSections();

  Stream<List<CatalogShop>> watchShops();

  Future<CatalogProduct?> productById(String id);
}
