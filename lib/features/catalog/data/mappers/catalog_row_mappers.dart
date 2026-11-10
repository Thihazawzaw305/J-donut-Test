import '../../domain/entities/catalog_banner.dart';
import '../../domain/entities/catalog_member.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/entities/catalog_shop.dart';
import '../../domain/entities/product_card_style.dart';
import '../datasources/local/app_database.dart';

CatalogMember mapMemberRow(MemberRow row) => CatalogMember(
  displayName: row.displayName,
  subtitleKey: row.subtitleKey,
  avatarAsset: row.avatarAsset,
  tierProgressKey: row.tierProgressKey,
  tierProgressKyats: row.tierProgressKyats,
  notificationCount: row.notificationCount,
  tierCode: row.tierCode,
  pointsBalance: row.pointsBalance,
  pointsToNextTier: row.pointsToNextTier,
  rewardsPillCount: row.rewardsPillCount,
  tierLadderFillBp: row.tierLadderFillBp,
);

CatalogProduct mapProductRow(ProductRow row) => CatalogProduct(
  id: row.id,
  code: row.code,
  nameKey: row.nameKey,
  priceMmk: row.priceMmk,
  isNew: row.isNew,
  discountPercent: row.discountPercent,
  imageAsset: row.imageAsset,
  imageUrl: row.imageUrl,
  descriptionKey: row.descriptionKey,
);

CatalogBanner mapBannerRow(BannerRow row) => CatalogBanner(
  id: row.id,
  imageAsset: row.imageAsset,
  sortOrder: row.sortOrder,
);

CatalogShop mapShopRow(ShopRow row) => CatalogShop(
  id: row.id,
  nameKey: row.nameKey,
  addressKey: row.addressKey,
  imageAsset: row.imageAsset,
  sortOrder: row.sortOrder,
);

ProductCardStyle mapCardStyle(String raw) => ProductCardStyle.fromSeed(raw);
