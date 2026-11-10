import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import 'onboarding_donut_slots.dart';

/// Five circular donut tiles that hold, then slide up together as one group.
/// Side tiles are cropped by the screen edge. [logo] crossfades between its
/// start and end positions during the move.
class OnboardingDonutHero extends StatefulWidget {
  const OnboardingDonutHero({super.key, required this.logo});

  final Widget logo;

  @override
  State<OnboardingDonutHero> createState() => _OnboardingDonutHeroState();
}

class _OnboardingDonutHeroState extends State<OnboardingDonutHero>
    with SingleTickerProviderStateMixin {
  static final _total =
      AppMotion.onboardingHeroHold + AppMotion.onboardingHeroMove;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _total);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.of(context, _total) == Duration.zero) {
      _controller.value = 1;
    } else if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _progress {
    final hold =
        AppMotion.onboardingHeroHold.inMilliseconds / _total.inMilliseconds;
    return ((_controller.value - hold) / (1 - hold)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, box) => AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Stack(
            children: [
              for (var i = 0; i < onboardingDonutTiles.length; i++)
                _tile(i, onboardingDonutTiles[i], box.biggest),
              _logo(box.biggest),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(int index, OnboardingDonutTile tile, Size area) {
    final size = tile.size * area.width;
    final dy = tile.dy + onboardingGroupOffset(_progress);
    return Positioned(
      key: ValueKey('onboarding_donut_$index'),
      left: area.width / 2 + tile.dx * area.width - size / 2,
      top: dy * area.height - size / 2,
      width: size,
      height: size,
      child: ClipOval(
        child: Transform.scale(
          scale: AppDimens.onboardingDonutImageZoom,
          child: Image.asset(tile.asset, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _logo(Size area) {
    final progress = _progress;
    return Positioned(
      left: 0,
      right: 0,
      top: onboardingLogoDy(progress) * area.height,
      child: FractionalTranslation(
        translation: const Offset(0, -0.5),
        child: Opacity(
          opacity: onboardingLogoOpacity(progress),
          child: widget.logo,
        ),
      ),
    );
  }
}
