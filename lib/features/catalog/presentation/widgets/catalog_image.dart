import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CatalogImage extends StatelessWidget {
  const CatalogImage({
    super.key,
    required this.asset,
    this.networkUrl,
    this.fit = BoxFit.cover,
  });

  final String asset;
  final String? networkUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = networkUrl;
  if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder: (_, _) => const _ImagePlaceholder(),
        errorWidget: (_, _, _) => _AssetImage(asset: asset, fit: fit),
      );
    }
    return _AssetImage(asset: asset, fit: fit);
  }
}

class _AssetImage extends StatelessWidget {
  const _AssetImage({required this.asset, required this.fit});

  final String asset;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      errorBuilder: (_, _, _) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.quantityTrack,
      child: Center(
        child: Icon(Icons.image_outlined, color: AppColors.textHint),
      ),
    );
  }
}
