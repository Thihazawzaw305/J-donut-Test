import 'catalog_product.dart';
import 'product_card_style.dart';

class CatalogSection {
  const CatalogSection({
    required this.id,
    required this.titleKey,
    required this.cardStyle,
    required this.productIds,
    required this.products,
  });

  final String id;
  final String titleKey;
  final ProductCardStyle cardStyle;
  final List<String> productIds;
  final List<CatalogProduct> products;
}
