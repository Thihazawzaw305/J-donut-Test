/// Medium carousel rows that share the larger home product card (Popular, Order again).
abstract final class HomeProductCardLayout {
  static bool isMediumFeaturedSection(String sectionId) =>
      sectionId == 'popular' || sectionId == 'orderAgain';
}
