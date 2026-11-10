import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';

/// Pull-to-refresh sliver placed below the home header, above product sections.
abstract final class HomeDonutRefreshControl {
  /// Donut spins in refresh state for [AppMotion.homeRefreshSpinLeadIn], then [onRefresh].
  static Future<void> refreshWithSpinLeadIn(
    Future<void> Function() onRefresh,
  ) async {
    await Future<void>.delayed(AppMotion.homeRefreshSpinLeadIn);
    await onRefresh();
  }

  static Widget sliver({required Future<void> Function() onRefresh}) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      refreshTriggerPullDistance: AppDimens.homeRefreshTriggerPull,
      refreshIndicatorExtent: AppDimens.homeRefreshIndicatorExtent,
      builder:
          (
            context,
            refreshState,
            pulledExtent,
            refreshTriggerPullDistance,
            refreshIndicatorExtent,
          ) {
            return HomeDonutRefreshIndicator(
              refreshState: refreshState,
              pulledExtent: pulledExtent,
              refreshTriggerPullDistance: refreshTriggerPullDistance,
            );
          },
    );
  }
}

class HomeDonutRefreshIndicator extends StatefulWidget {
  const HomeDonutRefreshIndicator({
    super.key,
    required this.refreshState,
    required this.pulledExtent,
    required this.refreshTriggerPullDistance,
  });

  final RefreshIndicatorMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;

  @override
  State<HomeDonutRefreshIndicator> createState() =>
      _HomeDonutRefreshIndicatorState();
}

class _HomeDonutRefreshIndicatorState extends State<HomeDonutRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: AppMotion.homeRefreshSpinPeriod,
    );
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeDonutRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSpin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncSpin();
  }

  void _syncSpin() {
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final refreshing = widget.refreshState == RefreshIndicatorMode.refresh;
    if (refreshing && !disableMotion) {
      _spin.repeat();
    } else {
      _spin.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final pulling =
        widget.refreshState == RefreshIndicatorMode.drag ||
        widget.refreshState == RefreshIndicatorMode.armed;
    final refreshing = widget.refreshState == RefreshIndicatorMode.refresh;

    final pullTurns = (widget.pulledExtent / widget.refreshTriggerPullDistance)
        .clamp(0.0, 1.2);

    Widget donut = Image.asset(
      key: const Key('home_refresh_donut_image'),
      AppAssets.homeRefreshDonut,
      width: AppDimens.homeRefreshDonutSize,
      height: AppDimens.homeRefreshDonutSize,
      fit: BoxFit.contain,
    );

    if (refreshing && !disableMotion) {
      donut = RotationTransition(turns: _spin, child: donut);
    } else if (pulling && !disableMotion) {
      donut = Transform.rotate(angle: pullTurns * math.pi * 2, child: donut);
    }

    final opacity = switch (widget.refreshState) {
      RefreshIndicatorMode.inactive => 0.0,
      RefreshIndicatorMode.done => 0.0,
      _ => (widget.pulledExtent / widget.refreshTriggerPullDistance).clamp(
        0.0,
        1.0,
      ),
    };

    return SizedBox(
      height: widget.pulledExtent.clamp(
        0.0,
        AppDimens.homeRefreshIndicatorExtent,
      ),
      child: Center(
        child: Opacity(opacity: refreshing ? 1.0 : opacity, child: donut),
      ),
    );
  }
}
