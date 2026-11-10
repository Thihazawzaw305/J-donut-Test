import 'dart:ui' show lerpDouble;

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

class HomeBottomNav extends ConsumerWidget {
  const HomeBottomNav({super.key, this.activeOverride});

  /// Tests may pin the active tab without Riverpod.
  final HomeShellTab? activeOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = activeOverride ?? ref.watch(homeShellTabProvider);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _HomeBottomNavItem(
                  key: const ValueKey('home_nav_home'),
                  selected: active == HomeShellTab.home,
                  label: l10n.homeNavHome,
                  icon: Icons.home_outlined,
                  onTap: () =>
                      _goShellTab(context, HomeShellTab.home, AppRoutes.home),
                ),
                _HomeBottomNavItem(
                  key: const ValueKey('home_nav_rewards'),
                  selected: active == HomeShellTab.rewards,
                  label: l10n.homeNavReward,
                  icon: Icons.emoji_events_outlined,
                  onTap: () => _goShellTab(
                    context,
                    HomeShellTab.rewards,
                    AppRoutes.rewards,
                  ),
                ),
                _HomeBottomNavItem(
                  key: const ValueKey('home_nav_order'),
                  selected: false,
                  label: l10n.homeNavOrder,
                  icon: Icons.takeout_dining_outlined,
                  onTap: () => AppToast.show(context, message: l10n.comingSoon),
                ),
                _HomeBottomNavItem(
                  key: const ValueKey('home_nav_wallet'),
                  selected: false,
                  label: l10n.homeNavWallet,
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () => AppToast.show(context, message: l10n.comingSoon),
                ),
                _HomeBottomNavItem(
                  key: const ValueKey('home_nav_settings'),
                  selected: active == HomeShellTab.settings,
                  label: l10n.homeNavSettings,
                  icon: Icons.settings_outlined,
                  onTap: () => _goShellTab(
                    context,
                    HomeShellTab.settings,
                    AppRoutes.settings,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goShellTab(BuildContext context, HomeShellTab tab, String route) {
    final container = ProviderScope.containerOf(context);
    final branch = homeShellBranchIndex(tab);

    container.read(homeShellTabProvider.notifier).setTab(tab);

    final shell = StatefulNavigationShell.maybeOf(context);
    if (shell != null && branch >= 0) {
      if (shell.currentIndex != branch) {
        shell.goBranch(branch, initialLocation: false);
      }
      return;
    }
    if (GoRouterState.of(context).uri.path == route) return;
    context.go(route);
  }
}

class _HomeBottomNavItem extends StatefulWidget {
  const _HomeBottomNavItem({
    super.key,
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
  State<_HomeBottomNavItem> createState() => _HomeBottomNavItemState();
}

class _HomeBottomNavItemState extends State<_HomeBottomNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.homeNavSelection,
      value: widget.selected ? 1 : 0,
    );
    _t = CurvedAnimation(parent: _controller, curve: AppMotion.standardCurve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = AppMotion.of(context, AppMotion.homeNavSelection);
  }

  @override
  void didUpdateWidget(_HomeBottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected == widget.selected) return;
    if (_controller.duration == Duration.zero) {
      _controller.value = widget.selected ? 1 : 0;
      return;
    }
    if (widget.selected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimens.homeNavPillRadius),
        child: AnimatedBuilder(
          animation: _t,
          builder: (context, _) {
            final t = _t.value;
            final pillHeight = lerpDouble(
              AppDimens.homeNavIconOnlyHeight,
              AppDimens.homeNavPillHeight,
              t,
            )!;
            return Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minWidth: AppDimens.iconMd + AppDimens.spaceMd * 2,
                minHeight: pillHeight,
                maxHeight: pillHeight,
              ),
              padding: EdgeInsets.lerp(
                const EdgeInsets.all(AppDimens.spaceSm),
                const EdgeInsets.symmetric(
                  horizontal: AppDimens.homeNavPillPaddingH,
                  vertical: AppDimens.homeNavPillPaddingV,
                ),
                t,
              ),
              decoration: BoxDecoration(
                color: Color.lerp(
                  Colors.transparent,
                  AppColors.homeNavActive,
                  t,
                ),
                borderRadius: BorderRadius.circular(
                  AppDimens.homeNavPillRadius,
                ),
                border: Border.all(
                  color: Color.lerp(
                    Colors.transparent,
                    AppColors.onPrimary,
                    t,
                  )!,
                  width: AppDimens.homeNavPillBorderWidth,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: AppColors.onPrimary,
                    size: AppDimens.iconMd,
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: t,
                      child: Opacity(
                        opacity: t,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppDimens.spaceXs,
                          ),
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            softWrap: false,
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                            style: AppTextStyles.bodyBold.copyWith(
                              color: AppColors.onPrimary,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
