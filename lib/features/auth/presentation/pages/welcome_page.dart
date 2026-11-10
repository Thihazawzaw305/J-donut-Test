import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/welcome_hero_gradient_overlay.dart';
import '../widgets/welcome_hero_image.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const WelcomeHeroImage(),
          const WelcomeHeroGradientOverlay(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Text(
                    context.l10n.welcomeHeadline,
                    style: AppTextStyles.headline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  PrimaryButton(
                    label: context.l10n.letsExplore,
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                  const SizedBox(height: AppDimens.spaceXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
