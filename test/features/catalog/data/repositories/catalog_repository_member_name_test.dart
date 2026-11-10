import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/data/datasources/local/app_database.dart';
import 'package:j_donuts_app/features/catalog/data/repositories/catalog_repository_impl.dart';

void main() {
  test('updateMemberDisplayName persists on default member row', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.into(db.memberRows).insert(
      MemberRowsCompanion.insert(
        id: 'default',
        displayName: 'Seed Name',
        subtitleKey: 'memberSubtitleEwallet',
        avatarAsset: 'assets/images/seed/member_avatar.png',
        tierProgressKey: 'memberTierProgressGold',
        tierProgressKyats: 50001,
        notificationCount: 0,
        tierCode: 'bronze',
        pointsBalance: 0,
        pointsToNextTier: 1290,
      ),
    );

    final repo = CatalogRepositoryImpl(db);
    await repo.updateMemberDisplayName('Ada');

    final row = await (db.select(db.memberRows)
          ..where((t) => t.id.equals('default')))
        .getSingle();
    expect(row.displayName, 'Ada');
  });
}
