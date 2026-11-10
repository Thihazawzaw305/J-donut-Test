import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/data/datasources/local/app_database.dart';

void main() {
  test('member row stores rewards columns', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db
        .into(db.memberRows)
        .insert(
          MemberRowsCompanion.insert(
            id: 'default',
            displayName: 'T',
            subtitleKey: 'memberSubtitleSilver',
            avatarAsset: 'a',
            tierProgressKey: 'memberTierProgressGold',
            tierProgressKyats: 0,
            notificationCount: 0,
            tierCode: 'silver',
            pointsBalance: 680000,
            pointsToNextTier: 500,
            rewardsPillCount: Value(3),
            tierLadderFillBp: Value(3500),
          ),
        );

    final row = await (db.select(db.memberRows)..limit(1)).getSingle();
    expect(row.rewardsPillCount, 3);
    expect(row.tierLadderFillBp, 3500);
  });
}
