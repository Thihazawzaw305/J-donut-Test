import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../catalog/domain/entities/catalog_banner.dart';
import '../../../catalog/domain/entities/catalog_member.dart';
import 'home_header_panel.dart';

/// Peach home header that fades and collapses as the catalog scrolls upward.
class HomeCollapsingHeader extends StatelessWidget {
  const HomeCollapsingHeader({
    super.key,
    required this.member,
    required this.banners,
  });

  final CatalogMember member;
  final List<CatalogBanner> banners;

  static double expandedHeight(BuildContext context) {
    return MediaQuery.paddingOf(context).top +
        AppDimens.homeHeaderExpandedBodyHeight;
  }

  @override
  Widget build(BuildContext context) {
    final height = expandedHeight(context);
    return SliverPersistentHeader(
      pinned: false,
      delegate: _HomeHeaderDelegate(
        maxHeight: height,
        member: member,
        banners: banners,
      ),
    );
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  _HomeHeaderDelegate({
    required this.maxHeight,
    required this.member,
    required this.banners,
  });

  final double maxHeight;
  final CatalogMember member;
  final List<CatalogBanner> banners;

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / maxHeight).clamp(0.0, 1.0);
    final opacity = (1 - progress).clamp(0.0, 1.0);
    final visibleHeight = (maxHeight - shrinkOffset).clamp(0.0, maxHeight);
    if (visibleHeight <= 0 || opacity <= 0) {
      return const SizedBox.shrink();
    }

    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final shiftY = disableMotion
        ? 0.0
        : -AppDimens.homeHeaderCollapseShift * progress;

    return SizedBox(
      height: visibleHeight,
      width: double.infinity,
      child: Opacity(
        opacity: opacity,
        child: ClipRect(
          child: Transform.translate(
            offset: Offset(0, shiftY),
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 1,
              child: HomeHeaderPanel(member: member, banners: banners),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return oldDelegate.maxHeight != maxHeight ||
        oldDelegate.member != member ||
        oldDelegate.banners != banners;
  }
}
