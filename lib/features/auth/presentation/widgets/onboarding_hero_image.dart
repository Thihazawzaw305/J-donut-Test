import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_motion.dart';

class OnboardingHeroImage extends StatelessWidget {
  const OnboardingHeroImage({
    super.key,
    required this.slideProgress,
  });

  final Animation<double> slideProgress;

  @override
  Widget build(BuildContext context) {
    final motion = AppMotion.of(context, AppMotion.onboardingSlide);
    final t = motion == Duration.zero ? 1.0 : slideProgress.value;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    const settled = AppMotion.onboardingHeroSettledFraction;
    final height = viewportHeight * (1 - (1 - settled) * t);
    final offsetY = -viewportHeight * (1 - settled) * t;

    return SizedBox(
      key: const Key('onboarding_hero_image'),
      height: height,
      width: double.infinity,
      child: ClipRect(
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: Image.asset(
            AppAssets.onboardingHero,
            fit: BoxFit.cover,
            width: MediaQuery.sizeOf(context).width,
            height: viewportHeight,
            errorBuilder: (context, error, stackTrace) => ColoredBox(
              color: AppColors.onboardingGradient.first,
            ),
          ),
        ),
      ),
    );
  }
}
