import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
class WelcomeHeroImage extends StatelessWidget {
  const WelcomeHeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      key: const Key('welcome_hero_image'),
      width: size.width,
      height: size.height,
      child: Image.asset(
        AppAssets.welcomeHero,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: size.width,
        height: size.height,
        errorBuilder: (context, error, stackTrace) => const ColoredBox(
          color: AppColors.backgroundBottom,
        ),
      ),
    );
  }
}
