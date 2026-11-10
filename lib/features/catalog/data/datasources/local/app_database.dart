import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'catalog_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MemberRows,
    ProductRows,
    BannerRows,
    SectionRows,
    SectionProductRows,
    ShopRows,
    ChallengeRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(memberRows, memberRows.rewardsPillCount);
            await migrator.addColumn(memberRows, memberRows.tierLadderFillBp);
          }
          if (from < 3) {
            await migrator.createTable(challengeRows);
          }
        },
      );

  Future<bool> hasProducts() async {
    final count = await customSelect(
      'SELECT COUNT(*) AS c FROM product_rows',
      readsFrom: {productRows},
    ).getSingle();
    return (count.data['c'] as int) > 0;
  }
}

Future<AppDatabase> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'j_donuts.db'));
  return AppDatabase(NativeDatabase(file));
}
