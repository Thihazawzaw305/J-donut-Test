import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/home_bottom_nav.dart';

/// Mirrors [StatefulNavigationShell.currentIndex] for off-screen shell branches.
final homeShellTabProvider = NotifierProvider<HomeShellTabNotifier, HomeShellTab>(
  HomeShellTabNotifier.new,
);

class HomeShellTabNotifier extends Notifier<HomeShellTab> {
  @override
  HomeShellTab build() => HomeShellTab.home;

  void setTab(HomeShellTab tab) {
    if (state == tab) return;
    state = tab;
  }
}
