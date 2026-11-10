import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/data/datasources/local/app_database.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_section.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_shop.dart';
import 'package:j_donuts_app/features/home/presentation/pages/home_page.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

const _viewport = Size(390, 2400);
const _errorText = 'Could not load this section.';
const _memberName = 'Test Member';

const _member = CatalogMember(
  displayName: _memberName,
  subtitleKey: 'memberSubtitleSilver',
  avatarAsset: 'assets/images/seed/member_avatar.png',
  tierProgressKey: 'memberTierProgressGold',
  tierProgressKyats: 0,
  notificationCount: 0,
  tierCode: 'silver',
  pointsBalance: 680000,
  pointsToNextTier: 500,
  rewardsPillCount: 3,
  tierLadderFillBp: 7500,
);

const _shop = CatalogShop(
  id: 'shop-1',
  nameKey: 'shopHledan',
  addressKey: 'shopHledanAddress',
  imageAsset: 'assets/images/seed/shop_hledan.jpg',
  sortOrder: 0,
);

void main() {
  var subscriptions = 0;

  Future<void> pumpHomeWithFailingSections(WidgetTester tester) async {
    subscriptions = 0;
    await tester.binding.setSurfaceSize(_viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: _viewport, disableAnimations: true),
        child: ProviderScope(
          overrides: [
            // Never queried: every catalog stream below is faked.
            databaseProvider.overrideWith((ref) async {
              final db = AppDatabase.memory();
              ref.onDispose(db.close);
              return db;
            }),
            catalogMemberProvider.overrideWith((ref) => Stream.value(_member)),
            catalogBannersProvider.overrideWith(
              (ref) => Stream.value(const []),
            ),
            catalogShopsProvider.overrideWith(
              (ref) => Stream.value(const [_shop]),
            ),
            catalogSectionsProvider.overrideWith((ref) {
              subscriptions++;
              // Drift failures are Exceptions, which Riverpod auto-retries.
              return Stream<List<CatalogSection>>.error(Exception('db'));
            }),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: HomePage()),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Unmounts Home and lets Riverpod's pending retry timers run out.
  Future<void> disposeHome(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 10));
  }

  testWidgets('failing sections show one retry panel straight away', (
    tester,
  ) async {
    await pumpHomeWithFailingSections(tester);

    expect(find.text(_errorText), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    await disposeHome(tester);
  });

  testWidgets('header and shops still render when sections fail', (
    tester,
  ) async {
    await pumpHomeWithFailingSections(tester);

    expect(find.text(_memberName), findsOneWidget);
    expect(find.textContaining("J'Donut shops near you"), findsOneWidget);
    expect(find.text('Hledan'), findsOneWidget);

    await disposeHome(tester);
  });

  testWidgets('tapping try again reloads the sections stream', (tester) async {
    await pumpHomeWithFailingSections(tester);
    final before = subscriptions;

    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(subscriptions, greaterThan(before));
    expect(find.text(_errorText), findsOneWidget);

    await disposeHome(tester);
  });
}
