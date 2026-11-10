import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/home_shell_tab_provider.dart';
import 'home_bottom_nav.dart';
import 'home_shell.dart';

class HomeTabShellPage extends ConsumerStatefulWidget {
  const HomeTabShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static HomeShellTab tabForBranchIndex(int index) => switch (index) {
    0 => HomeShellTab.home,
    1 => HomeShellTab.rewards,
    2 => HomeShellTab.settings,
    _ => HomeShellTab.home,
  };

  @override
  ConsumerState<HomeTabShellPage> createState() => _HomeTabShellPageState();
}

class _HomeTabShellPageState extends ConsumerState<HomeTabShellPage> {
  @override
  void initState() {
    super.initState();
    _syncShellTabToProvider(postFrame: true);
  }

  @override
  void didUpdateWidget(HomeTabShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      _syncShellTabToProvider(postFrame: true);
    }
  }

  void _syncShellTabToProvider({bool postFrame = false}) {
    void apply() {
      if (!mounted) return;
      final tab = HomeTabShellPage.tabForBranchIndex(
        widget.navigationShell.currentIndex,
      );
      if (ref.read(homeShellTabProvider) != tab) {
        ref.read(homeShellTabProvider.notifier).setTab(tab);
      }
    }

    if (postFrame) {
      WidgetsBinding.instance.addPostFrameCallback((_) => apply());
    } else {
      apply();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeShell(body: widget.navigationShell);
  }
}
