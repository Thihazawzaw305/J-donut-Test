enum ProductCardStyle {
  largeRect,
  mediumRect,
  square;

  static ProductCardStyle fromSeed(String raw) => switch (raw) {
    'largeRect' => ProductCardStyle.largeRect,
    'mediumRect' => ProductCardStyle.mediumRect,
    'square' => ProductCardStyle.square,
    _ => ProductCardStyle.square,
  };
}
