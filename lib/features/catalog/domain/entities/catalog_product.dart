class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.code,
    required this.nameKey,
    required this.priceMmk,
    required this.isNew,
    required this.discountPercent,
    required this.imageAsset,
    required this.imageUrl,
    required this.descriptionKey,
  });

  final String id;
  final String code;
  final String nameKey;
  final int priceMmk;
  final bool isNew;
  final int? discountPercent;
  final String imageAsset;
  final String? imageUrl;
  final String descriptionKey;
}
