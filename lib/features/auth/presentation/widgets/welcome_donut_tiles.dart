import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';

/// Decorative donut previews that slide in with stagger (Welcome screen).
class WelcomeDonutTiles extends StatefulWidget {
  const WelcomeDonutTiles({super.key});

  static const _tileAssets = [
    'assets/images/seed/p_coconut.png',
    'assets/images/seed/p_candy_ring.png',
    'assets/images/seed/p_happy_bloom.png',
    'assets/images/seed/p_monster_black.png',
  ];

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
    final total = AppMotion.welcomeDonutEntrance +
        AppMotion.welcomeDonutStagger * WelcomeDonutTiles._tileAssets.length;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.welcomeDonutTileSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < WelcomeDonutTiles._tileAssets.length; i++) ...[
            if (i > 0) const SizedBox(width: AppDimens.spaceSm),
            _StaggeredTile(
              index: i,
              asset: WelcomeDonutTiles._tileAssets[i],
              progress: _controller,
            ),
          ],
        ],
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
    final totalMs = AppMotion.welcomeDonutEntrance.inMilliseconds +
        AppMotion.welcomeDonutStagger.inMilliseconds *
            WelcomeDonutTiles._tileAssets.length;
    final startMs = index * AppMotion.welcomeDonutStagger.inMilliseconds;
    final endMs = startMs + AppMotion.welcomeDonutEntrance.inMilliseconds;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final t = progress.value <= startMs / totalMs
            ? 0.0
            : progress.value >= endMs / totalMs
            ? 1.0
            : Curves.easeOutCubic.transform(
                ((progress.value * totalMs) - startMs) /
                    AppMotion.welcomeDonutEntrance.inMilliseconds,
              );
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, AppMotion.onboardingSlideUp * (1 - t)),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.welcomeDonutTileRadius),
        child: Image.asset(
          asset,
          width: AppDimens.welcomeDonutTileSize,
          height: AppDimens.welcomeDonutTileSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
