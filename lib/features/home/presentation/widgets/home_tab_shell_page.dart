import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_bottom_nav.dart';
import 'home_shell.dart';

class HomeTabShellPage extends StatelessWidget {
  const HomeTabShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static HomeShellTab tabForBranchIndex(int index) => switch (index) {
        0 => HomeShellTab.home,
        1 => HomeShellTab.rewards,
        2 => HomeShellTab.settings,
        _ => HomeShellTab.home,
      };

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      activeTab: tabForBranchIndex(navigationShell.currentIndex),
      body: navigationShell,
    );
  }
}
