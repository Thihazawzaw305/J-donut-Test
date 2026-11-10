import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/home/presentation/providers/home_shell_tab_provider.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:j_donuts_app/features/rewards/presentation/pages/rewards_page.dart';

import '../../../../helpers/pump_app.dart';

class _InitialShellTabNotifier extends HomeShellTabNotifier {
  _InitialShellTabNotifier(this.initial);
  final HomeShellTab initial;

  @override
  HomeShellTab build() => initial;
}

const _member = CatalogMember(
  displayName: 'T',
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

Widget _scoped(
  Widget child, {
  bool disableAnimations = false,
  HomeShellTab shellTab = HomeShellTab.rewards,
}) {
  return ProviderScope(
    overrides: [
      catalogMemberProvider.overrideWith((ref) => Stream.value(_member)),
      catalogChallengesProvider.overrideWith((ref) => Stream.value(const [])),
      homeShellTabProvider.overrideWith(
        () => _InitialShellTabNotifier(shellTab),
      ),
    ],
    child: disableAnimations
        ? MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: child,
          )
        : child,
  );
}

void main() {
  testWidgets('shows rewards screen title when member loads', (tester) async {
    await tester.pumpApp(_scoped(const RewardsPage()));
    await tester.pump();

    expect(find.textContaining("J' Donuts"), findsOneWidget);
  });

  testWidgets('entrance plays when shell tab switches to rewards', (
    tester,
  ) async {
    await tester.pumpApp(
      ProviderScope(
        overrides: [
          catalogMemberProvider.overrideWith((ref) => Stream.value(_member)),
          catalogChallengesProvider.overrideWith(
            (ref) => Stream.value(const []),
          ),
          homeShellTabProvider.overrideWith(
            () => _InitialShellTabNotifier(HomeShellTab.home),
          ),
        ],
        child: const RewardsPage(),
      ),
    );
    await tester.pump();

    expect(find.text('0'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RewardsPage)),
    );
    container.read(homeShellTabProvider.notifier).setTab(HomeShellTab.rewards);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    expect(find.textContaining('680'), findsNothing);
  });

  testWidgets('reduce motion shows final points immediately', (tester) async {
    await tester.pumpApp(_scoped(const RewardsPage(), disableAnimations: true));
    await tester.pump();

    expect(find.textContaining('680,000'), findsOneWidget);
  });
}
