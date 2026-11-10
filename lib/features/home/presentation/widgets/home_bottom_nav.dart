import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/home_shell_tab_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_toast.dart';

enum HomeShellTab { home, rewards, order, wallet, settings }

int homeShellBranchIndex(HomeShellTab tab) => switch (tab) {
      HomeShellTab.home => 0,
      HomeShellTab.rewards => 1,
      HomeShellTab.settings => 2,
      HomeShellTab.order || HomeShellTab.wallet => -1,
    };

/// Full-bleed accent band behind the inset cyan bar (lower half of nav height).
class HomeBottomNavAccentStrip extends StatelessWidget {
  const HomeBottomNavAccentStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: AppDimens.homeNavHeight / 2 + bottomSafe,
      child: const ColoredBox(color: AppColors.accent),
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, required this.active});

  final HomeShellTab active;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMd,
          AppDimens.spaceSm,
          AppDimens.spaceMd,
          0,
        ),
        child: Material(
          color: AppColors.homeNavBar,
          elevation: 6,
          shadowColor: AppColors.shadow,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimens.homeNavRadius),
            ),
          ),
          child: SizedBox(
            height: AppDimens.homeNavHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _HomeBottomNavItem(
                  selected: active == HomeShellTab.home,
                  label: l10n.homeNavHome,
                  icon: Icons.home_outlined,
                      onTap: () => _goShellTab(context, HomeShellTab.home, AppRoutes.home),
                ),
                _HomeBottomNavItem(
                  selected: active == HomeShellTab.rewards,
                  label: l10n.homeNavReward,
                  icon: Icons.emoji_events_outlined,
                      onTap: () => _goShellTab(context, HomeShellTab.rewards, AppRoutes.rewards),
                ),
                _HomeBottomNavItem(
                  selected: false,
                  label: l10n.homeNavOrder,
                  icon: Icons.takeout_dining_outlined,
                  onTap: () =>
                      AppToast.show(context, message: l10n.comingSoon),
                ),
                _HomeBottomNavItem(
                  selected: false,
                  label: l10n.homeNavWallet,
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () =>
                      AppToast.show(context, message: l10n.comingSoon),
                ),
                _HomeBottomNavItem(
                  selected: active == HomeShellTab.settings,
                  label: l10n.homeNavSettings,
                  icon: Icons.settings_outlined,
                      onTap: () => _goShellTab(context, HomeShellTab.settings, AppRoutes.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goShellTab(BuildContext context, HomeShellTab tab, String route) {
    ProviderScope.containerOf(context)
        .read(homeShellTabProvider.notifier)
        .setTab(tab);

    final branch = homeShellBranchIndex(tab);
    final shell = StatefulNavigationShell.maybeOf(context);
    if (shell != null && branch >= 0) {
      shell.goBranch(branch, initialLocation: false);
      return;
    }
    if (GoRouterState.of(context).uri.path == route) return;
    context.go(route);
  }
}

class _HomeBottomNavItem extends StatelessWidget {
  const _HomeBottomNavItem({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.homeNavSelection);
    const curve = AppMotion.standardCurve;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.homeNavPillRadius),
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        constraints: BoxConstraints(
          minWidth: AppDimens.iconMd + AppDimens.spaceMd * 2,
          minHeight: selected
              ? 0
              : AppDimens.iconMd + AppDimens.spaceMd * 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: selected
              ? AppDimens.homeNavPillPaddingH
              : AppDimens.spaceSm,
          vertical: selected
              ? AppDimens.homeNavPillPaddingV
              : AppDimens.spaceSm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.homeNavActive : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.homeNavPillRadius),
          border: selected
              ? Border.all(
                  color: AppColors.onPrimary,
                  width: AppDimens.homeNavPillBorderWidth,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onPrimary, size: AppDimens.iconMd),
            AnimatedSize(
              duration: duration,
              curve: curve,
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.hardEdge,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppDimens.spaceXs),
                      child: Text(
                        label,
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    )
                  : const SizedBox(width: 0, height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
