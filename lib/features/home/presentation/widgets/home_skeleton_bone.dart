import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer_bone.dart';

/// Shimmer placeholder block for home loading skeletons.
class HomeSkeletonBone extends StatelessWidget {
  const HomeSkeletonBone({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ShimmerBone(width: width, height: height, radius: radius);
  }
}
