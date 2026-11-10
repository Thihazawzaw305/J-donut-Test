import 'package:drift/drift.dart';

class MemberRows extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text()();
  TextColumn get subtitleKey => text()();
  TextColumn get avatarAsset => text()();
  TextColumn get tierProgressKey => text()();
  IntColumn get tierProgressKyats => integer()();
  IntColumn get notificationCount => integer()();
  TextColumn get tierCode => text()();
  IntColumn get pointsBalance => integer()();
  IntColumn get pointsToNextTier => integer()();
  IntColumn get rewardsPillCount => integer().withDefault(const Constant(0))();
  IntColumn get tierLadderFillBp => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProductRows extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get nameKey => text()();
  IntColumn get priceMmk => integer()();
  BoolColumn get isNew => boolean()();
  IntColumn get discountPercent => integer().nullable()();
  TextColumn get imageAsset => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get descriptionKey => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BannerRows extends Table {
  TextColumn get id => text()();
  TextColumn get imageAsset => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SectionRows extends Table {
  TextColumn get id => text()();
  TextColumn get titleKey => text()();
  TextColumn get cardStyle => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SectionProductRows extends Table {
  TextColumn get sectionId => text()();
  TextColumn get productId => text()();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {sectionId, productId};
}

class ChallengeRows extends Table {
  TextColumn get id => text()();
  TextColumn get tab => text()();
  TextColumn get kind => text()();
  TextColumn get titleKey => text()();
  IntColumn get progressCurrent => integer()();
  IntColumn get progressTotal => integer()();
  IntColumn get pointsReward => integer()();
  TextColumn get imageAsset => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ShopRows extends Table {
  TextColumn get id => text()();
  TextColumn get nameKey => text()();
  TextColumn get addressKey => text()();
  TextColumn get imageAsset => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
