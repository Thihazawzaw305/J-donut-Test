class CatalogShop {
  const CatalogShop({
    required this.id,
    required this.nameKey,
    required this.addressKey,
    required this.imageAsset,
    required this.sortOrder,
  });

  final String id;
  final String nameKey;
  final String addressKey;
  final String imageAsset;
  final int sortOrder;
}
