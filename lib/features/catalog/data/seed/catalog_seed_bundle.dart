import '../../domain/entities/catalog_banner.dart';
import '../../domain/entities/catalog_challenge.dart';
import '../../domain/entities/catalog_member.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/entities/catalog_section.dart';
import '../../domain/entities/catalog_shop.dart';
import '../../domain/entities/product_card_style.dart';

class CatalogSeedBundle {
  CatalogSeedBundle({
    required this.member,
    required this.banners,
    required this.products,
    required this.sections,
    required this.shops,
    required this.challenges,
  });

  final CatalogMember member;
  final List<CatalogBanner> banners;
  final List<CatalogProduct> products;
  final List<CatalogSection> sections;
  final List<CatalogShop> shops;
  final List<CatalogChallenge> challenges;

  factory CatalogSeedBundle.fromJson(Map<String, dynamic> json) {
    final productById = <String, CatalogProduct>{};
    final products = (json['products'] as List<dynamic>)
        .map((e) => _parseProduct(e as Map<String, dynamic>))
        .toList();
    for (final p in products) {
      productById[p.id] = p;
    }

    final sections = (json['sections'] as List<dynamic>).map((e) {
      final map = e as Map<String, dynamic>;
      final ids = (map['productIds'] as List<dynamic>).cast<String>();
      return CatalogSection(
        id: map['id'] as String,
        titleKey: map['titleKey'] as String,
        cardStyle: ProductCardStyle.fromSeed(map['cardStyle'] as String),
        productIds: ids,
        products: [
          for (final id in ids)
            if (productById[id] != null) productById[id]!,
        ],
      );
    }).toList();

    return CatalogSeedBundle(
      member: _parseMember(json['member'] as Map<String, dynamic>),
      banners: (json['banners'] as List<dynamic>)
          .map((e) => _parseBanner(e as Map<String, dynamic>))
          .toList(),
      products: products,
      sections: sections,
      shops: (json['shops'] as List<dynamic>)
          .map((e) => _parseShop(e as Map<String, dynamic>))
          .toList(),
      challenges: (json['challenges'] as List<dynamic>? ?? const [])
          .map((e) => _parseChallenge(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

CatalogMember _parseMember(Map<String, dynamic> json) => CatalogMember(
  displayName: json['displayName'] as String,
  subtitleKey: json['subtitleKey'] as String,
  avatarAsset: json['avatarAsset'] as String,
  tierProgressKey: json['tierProgressKey'] as String,
  tierProgressKyats: json['tierProgressKyats'] as int,
  notificationCount: json['notificationCount'] as int,
  tierCode: json['tierCode'] as String,
  pointsBalance: json['pointsBalance'] as int,
  pointsToNextTier: json['pointsToNextTier'] as int,
  rewardsPillCount: json['rewardsPillCount'] as int? ?? 0,
  tierLadderFillBp: json['tierLadderFillBp'] as int? ?? 0,
);

CatalogBanner _parseBanner(Map<String, dynamic> json) => CatalogBanner(
  id: json['id'] as String,
  imageAsset: json['imageAsset'] as String,
  sortOrder: json['sortOrder'] as int,
);

CatalogProduct _parseProduct(Map<String, dynamic> json) => CatalogProduct(
  id: json['id'] as String,
  code: json['code'] as String,
  nameKey: json['nameKey'] as String,
  priceMmk: json['priceMmk'] as int,
  isNew: json['isNew'] as bool,
  discountPercent: json['discountPercent'] as int?,
  imageAsset: json['imageAsset'] as String,
  imageUrl: json['imageUrl'] as String?,
  descriptionKey: json['descriptionKey'] as String,
);

CatalogChallenge _parseChallenge(Map<String, dynamic> json) => CatalogChallenge(
  id: json['id'] as String,
  tab: CatalogChallengeTab.fromSeed(json['tab'] as String),
  kind: CatalogChallengeKind.fromSeed(json['kind'] as String),
  titleKey: json['titleKey'] as String,
  progressCurrent: json['progressCurrent'] as int,
  progressTotal: json['progressTotal'] as int,
  pointsReward: json['pointsReward'] as int,
  imageAsset: json['imageAsset'] as String,
  sortOrder: json['sortOrder'] as int,
);

CatalogShop _parseShop(Map<String, dynamic> json) => CatalogShop(
  id: json['id'] as String,
  nameKey: json['nameKey'] as String,
  addressKey: json['addressKey'] as String,
  imageAsset: json['imageAsset'] as String,
  sortOrder: json['sortOrder'] as int,
);
