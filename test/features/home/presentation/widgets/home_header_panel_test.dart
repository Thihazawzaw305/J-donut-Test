import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/theme/app_text_styles.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_banner.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_header_panel.dart';

import '../../../../helpers/pump_app.dart';

const _member = CatalogMember(
  displayName: 'Hania',
  subtitleKey: 'memberSubtitleEwallet',
  avatarAsset: 'assets/images/seed/member_avatar.png',
  tierProgressKey: 'memberTierProgressSilver',
  tierProgressKyats: 50001,
  notificationCount: 2,
  tierCode: 'bronze',
  pointsBalance: 0,
  pointsToNextTier: 1290,
);

const _banners = [
  CatalogBanner(
    id: 'b1',
    imageAsset: 'assets/images/seed/banner_promo_one.jpg',
    sortOrder: 0,
  ),
];

void main() {
  testWidgets('shows compact member name and hugging tier pill', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpApp(
      HomeHeaderPanel(member: _member, banners: _banners),
    );
    await tester.pumpAndSettle();

    final name = tester.widget<Text>(find.text('Hania'));
    expect(name.style?.fontSize, AppTextStyles.homeMemberName.fontSize);

    expect(find.textContaining('50,001'), findsOneWidget);
    final tierText = find.textContaining('kyats left');
    expect(tierText, findsOneWidget);

    final tierLabel = tester.widget<Text>(tierText);
    expect(tierLabel.style?.fontSize, AppTextStyles.homeTierPill.fontSize);

    const pillFinder = Key('home_tier_pill');
    final pillBox = tester.getSize(find.byKey(pillFinder));
    final screenWidth = tester.getSize(find.byType(HomeHeaderPanel)).width;
    expect(pillBox.width, lessThan(screenWidth));
    expect(pillBox.width, greaterThan(120));

    final pillLeft = tester.getTopLeft(find.byKey(pillFinder));
    final headerLeft = tester.getTopLeft(find.byType(HomeHeaderPanel));
    expect(pillLeft.dx - headerLeft.dx, lessThan(40));
  });
}
