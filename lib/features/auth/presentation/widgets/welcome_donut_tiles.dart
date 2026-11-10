import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';

/// Two-column staggered donut cards that slide in (Welcome screen).
///
/// Cards bleed past the bottom edge; a gradient overlay fades them out.
class WelcomeDonutTiles extends StatefulWidget {
  const WelcomeDonutTiles({super.key});

  static const _assets = AppAssets.welcomeTiles;
  @override
  State<WelcomeDonutTiles> createState() => _WelcomeDonutTilesState();
}

class _WelcomeDonutTilesState extends State<WelcomeDonutTiles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _playEntrance());
  }

  void _playEntrance() {
    if (!mounted) return;
    final total =
        AppMotion.welcomeDonutEntrance +
        AppMotion.welcomeDonutStagger * WelcomeDonutTiles._assets.length;
    final duration = AppMotion.of(context, total);
    _controller.duration = duration;
    if (duration == Duration.zero) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _column(int column) {
    final tiles = <Widget>[];
    for (var i = column; i < WelcomeDonutTiles._assets.length; i += 2) {
      if (tiles.isNotEmpty) {
        tiles.add(const SizedBox(height: AppDimens.welcomeTileGap));
      }
      tiles.add(
        _StaggeredTile(
          index: i,
          asset: WelcomeDonutTiles._assets[i],
          progress: _controller,
        ),
      );
    }
    final offset = column.isOdd ? AppDimens.welcomeTileColumnOffset : 0.0;
    return Expanded(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: 0,
        maxHeight: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: offset),
          child: Column(mainAxisSize: MainAxisSize.min, children: tiles),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.welcomeTileGap,
          AppDimens.welcomeTileTopInset,
          AppDimens.welcomeTileGap,
          0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _column(0),
            const SizedBox(width: AppDimens.welcomeTileGap),
            _column(1),
          ],
        ),
      ),
    );
  }
}

class _StaggeredTile extends StatelessWidget {
  const _StaggeredTile({
    required this.index,
    required this.asset,
    required this.progress,
  });

  final int index;
  final String asset;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final totalMs =
        AppMotion.welcomeDonutEntrance.inMilliseconds +
        AppMotion.welcomeDonutStagger.inMilliseconds *
            WelcomeDonutTiles._assets.length;
    final startMs = index * AppMotion.welcomeDonutStagger.inMilliseconds;
    final spanMs = AppMotion.welcomeDonutEntrance.inMilliseconds;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final raw = ((progress.value * totalMs) - startMs) / spanMs;
        final t = AppMotion.standardCurve.transform(raw.clamp(0.0, 1.0));
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, AppMotion.welcomeTileSlide * (1 - t)),
            child: child,
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: AppDimens.welcomeTileAspect,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.welcomeTileRadius),
          child: Image.asset(asset, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
