enum CatalogChallengeTab {
  eat,
  gift;

  static CatalogChallengeTab fromSeed(String raw) {
    return switch (raw) {
      'gift' => CatalogChallengeTab.gift,
      _ => CatalogChallengeTab.eat,
    };
  }
}

enum CatalogChallengeKind {
  donut,
  coffee;

  static CatalogChallengeKind fromSeed(String raw) {
    return switch (raw) {
      'coffee' => CatalogChallengeKind.coffee,
      _ => CatalogChallengeKind.donut,
    };
  }
}

class CatalogChallenge {
  const CatalogChallenge({
    required this.id,
    required this.tab,
    required this.kind,
    required this.titleKey,
    required this.progressCurrent,
    required this.progressTotal,
    required this.pointsReward,
    required this.imageAsset,
    required this.sortOrder,
  });

  final String id;
  final CatalogChallengeTab tab;
  final CatalogChallengeKind kind;
  final String titleKey;
  final int progressCurrent;
  final int progressTotal;
  final int pointsReward;
  final String imageAsset;
  final int sortOrder;
}
