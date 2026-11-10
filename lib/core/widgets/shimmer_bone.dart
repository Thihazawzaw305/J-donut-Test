import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_motion.dart';

/// Pulsing shimmer placeholder; static fill when reduce motion is on.
class ShimmerBone extends StatefulWidget {
  const ShimmerBone({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
    this.baseColor = AppColors.skeletonBase,
    this.highlightColor = AppColors.skeletonHighlight,
  });

  final double width;
  final double height;
  final double radius;
  final Color baseColor;
  final Color highlightColor;

  @override
  State<ShimmerBone> createState() => _ShimmerBoneState();
}

class _ShimmerBoneState extends State<ShimmerBone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.homeShimmerPeriod,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bone = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.baseColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    );

    if (MediaQuery.disableAnimationsOf(context)) {
      return bone;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final slide = -1.0 + _controller.value * 2;
            return LinearGradient(
              begin: Alignment(slide - 1, 0),
              end: Alignment(slide + 1, 0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: bone,
    );
  }
}
