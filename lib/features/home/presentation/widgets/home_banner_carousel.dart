import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
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
  Timer? _autoAdvance;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleAutoAdvance();
  }

  void _scheduleAutoAdvance() {
    _autoAdvance?.cancel();
    _autoAdvance = null;
    if (widget.banners.length < 2) return;
    if (MediaQuery.disableAnimationsOf(context)) return;

    final interval = AppMotion.of(context, AppMotion.homeBannerAutoAdvance);
    if (interval == Duration.zero) return;

    _autoAdvance = Timer.periodic(interval, (_) {
      if (!_controller.hasClients) return;
      final next = _controller.page!.round() + 1;
      _controller.animateToPage(
        next,
        duration: AppMotion.of(context, AppMotion.medium),
        curve: AppMotion.standardCurve,
      );
    });
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
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

    return SizedBox(
      height: AppDimens.homeBannerHeight,
      child: PageView.builder(
        controller: _controller,
        padEnds: false,
        itemCount: virtualCount,
        itemBuilder: (context, index) {
          final banner = widget.banners[index % bannerCount];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.homeBannerItemPaddingH,
            ),
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
    );
  }
}
