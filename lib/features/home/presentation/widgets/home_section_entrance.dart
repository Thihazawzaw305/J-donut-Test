import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';

/// Staggered fade/slide when a home catalog section first appears.
class HomeSectionEntrance extends StatefulWidget {
  const HomeSectionEntrance({
    super.key,
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  State<HomeSectionEntrance> createState() => _HomeSectionEntranceState();
}

class _HomeSectionEntranceState extends State<HomeSectionEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.homeSectionEntrance,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _play());
  }

  Future<void> _play() async {
    if (!mounted) return;
    final stagger = AppMotion.of(
      context,
      AppMotion.homeSectionEntranceStagger * widget.index,
    );
    if (stagger > Duration.zero) {
      await Future<void>.delayed(stagger);
    }
    if (!mounted) return;
    final duration = AppMotion.of(context, AppMotion.homeSectionEntrance);
    _controller.duration = duration;
    if (duration == Duration.zero) {
      _controller.value = 1;
    } else {
      await _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, AppMotion.onboardingSlideUp * (1 - t)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
