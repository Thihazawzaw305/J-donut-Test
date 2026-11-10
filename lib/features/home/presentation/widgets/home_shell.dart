import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'home_bottom_nav.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({
    super.key,
    required this.activeTab,
    required this.body,
  });

  final HomeShellTab activeTab;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.homeScreenBackground,
      body: body,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          const HomeBottomNavAccentStrip(),
          HomeBottomNav(active: activeTab),
        ],
      ),
    );
  }
}
