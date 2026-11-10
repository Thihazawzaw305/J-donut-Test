import '../../catalog/domain/entities/catalog_section.dart';
import '../../catalog/domain/entities/product_card_style.dart';

/// Empty section shells shown with a retry panel when the sections stream
/// fails, so the rest of Home (header, banners, shops) keeps rendering.
const homeFallbackSections = [
  CatalogSection(
    id: 'seasonal',
    titleKey: 'homeSectionSeasonal',
    cardStyle: ProductCardStyle.largeRect,
    productIds: [],
    products: [],
  ),
  CatalogSection(
    id: 'popular',
    titleKey: 'homeSectionPopular',
    cardStyle: ProductCardStyle.mediumRect,
    productIds: [],
    products: [],
  ),
  CatalogSection(
    id: 'orderAgain',
    titleKey: 'homeSectionOrderAgain',
    cardStyle: ProductCardStyle.mediumRect,
    productIds: [],
    products: [],
  ),
];
