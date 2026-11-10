import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';

/// Staggered fade and slide-up for onboarding CTA block.
class OnboardingBottomEntrance extends StatefulWidget {
  const OnboardingBottomEntrance({
    super.key,
    this.autoStart = true,
    required this.children,
  });

  final bool autoStart;
  final List<Widget> children;

  @override
  State<OnboardingBottomEntrance> createState() =>
      OnboardingBottomEntranceState();
}

class OnboardingBottomEntranceState extends State<OnboardingBottomEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _totalDuration);
  }

  void beginEntrance() {
    if (_started) return;
    _started = true;
    if (_controller.duration == Duration.zero) {
      _controller.value = 1;
      return;
    }
    if (_controller.status != AnimationStatus.completed) {
      _controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = AppMotion.of(context, _totalDuration);
    if (duration == Duration.zero) {
      _controller.duration = Duration.zero;
      _controller.value = 1;
      _started = true;
    } else if (_controller.duration != duration) {
      _controller.duration = duration;
      _maybeAutoStart();
    } else {
      _maybeAutoStart();
    }
  }

  void _maybeAutoStart() {
    if (!widget.autoStart || _started) return;
    if (_controller.status == AnimationStatus.dismissed) {
      _started = true;
      _controller.forward();
    }
  }

  Duration get _totalDuration {
    final n = widget.children.length;
    if (n == 0) return Duration.zero;
    return AppMotion.onboardingBottomDelay +
        AppMotion.onboardingBottomEntrance +
        AppMotion.onboardingBottomStagger * (n - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _totalDuration.inMilliseconds;
    if (totalMs == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.children,
      );
    }

    final delayMs = AppMotion.onboardingBottomDelay.inMilliseconds;
    final staggerMs = AppMotion.onboardingBottomStagger.inMilliseconds;
    final entranceMs = AppMotion.onboardingBottomEntrance.inMilliseconds;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < widget.children.length; i++)
              _StaggeredChild(
                progress: _controller.value,
                start: (delayMs + i * staggerMs) / totalMs,
                end: (delayMs + i * staggerMs + entranceMs) / totalMs,
                child: widget.children[i],
              ),
          ],
        );
      },
    );
  }
}

class _StaggeredChild extends StatelessWidget {
  const _StaggeredChild({
    required this.progress,
    required this.start,
    required this.end,
    required this.child,
  });

  final double progress;
  final double start;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = progress <= start
        ? 0.0
        : progress >= end
        ? 1.0
        : Curves.easeOutCubic.transform((progress - start) / (end - start));

    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, AppMotion.onboardingSlideUp * (1 - t)),
        child: child,
      ),
    );
  }
}
