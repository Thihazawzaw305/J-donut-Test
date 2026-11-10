import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../catalog/domain/entities/catalog_banner.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key, required this.banners});

  final List<CatalogBanner> banners;

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    final count = widget.banners.length;
    final initialPage = count < 2
        ? 0
        : (AppDimens.homeBannerVirtualPageCount ~/ 2 ~/ count) * count;
    _controller = PageController(
      viewportFraction: AppDimens.homeBannerViewportFraction,
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final bannerCount = widget.banners.length;
    final virtualCount = bannerCount < 2
        ? bannerCount
        : AppDimens.homeBannerVirtualPageCount;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.homeHeaderPaddingBottom),
      child: SizedBox(
        height: AppDimens.homeBannerHeight,
        child: PageView.builder(
          controller: _controller,
          itemCount: virtualCount,
          itemBuilder: (context, index) {
            final banner = widget.banners[index % bannerCount];
            return Padding(
              padding: const EdgeInsets.only(left: AppDimens.spaceMd),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimens.homeBannerRadius),
                  topRight: Radius.circular(AppDimens.homeBannerRadius),
                ),
                child: CatalogImage(
                  asset: banner.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
