import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/data/seed/catalog_seed_bundle.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('catalog_v1 seed parses member and coconut product', () async {
  final json = await rootBundle.loadString('assets/seed/catalog_v1.json');
    final bundle = CatalogSeedBundle.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );

    expect(bundle.member.displayName, 'Thiha Zaw Zaw');
    expect(bundle.member.notificationCount, 2);
    expect(bundle.member.tierCode, 'silver');
    expect(bundle.member.pointsBalance, 680000);
    expect(bundle.member.pointsToNextTier, 500);
    expect(bundle.member.rewardsPillCount, 3);
    expect(bundle.member.tierLadderFillBp, 5800);
    expect(
      bundle.products.any((p) => p.id == 'p_coconut' && p.priceMmk == 3200),
      isTrue,
    );
    expect(bundle.sections.first.productIds, isNotEmpty);
  });
}
