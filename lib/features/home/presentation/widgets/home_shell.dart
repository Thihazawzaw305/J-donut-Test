import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/rewards_system_ui.dart';
import '../providers/home_shell_tab_provider.dart';
import 'home_bottom_nav.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({
    super.key,
    required this.body,
    this.activeTabOverride,
  });

  final Widget body;

  /// Widget tests can pin the active shell tab without navigation.
  final HomeShellTab? activeTabOverride;

  static const _navKey = GlobalObjectKey('home_shell_bottom_nav');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = activeTabOverride ?? ref.watch(homeShellTabProvider);
    final isRewards = activeTab == HomeShellTab.rewards;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isRewards
          ? RewardsSystemUi.overlayStyle
          : RewardsSystemUi.homeOverlayStyle,
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.homeScreenBackground,
        body: body,
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            const HomeBottomNavAccentStrip(),
            HomeBottomNav(
              key: _navKey,
              activeOverride: activeTabOverride,
            ),
          ],
        ),
      ),
    );
  }
}
