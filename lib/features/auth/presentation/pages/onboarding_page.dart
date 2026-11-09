import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/legal_footer.dart';
import '../widgets/login_prompt.dart';
import '../widgets/onboarding_hero.dart';
import '../widgets/social_login_row.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: AppColors.onboardingGradient,
        child: SafeArea(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: OnboardingHero()),
        _buildBottomSection(context),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.onboardingPadding,
        ),
        child: _buildActions(context),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    void comingSoon() =>
        AppToast.show(context, message: context.l10n.comingSoon);

    return Column(
      children: [
        PrimaryButton(
          label: context.l10n.getStarted,
          onPressed: () => context.push(AppRoutes.registerPhone),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        LoginPrompt(onLogIn: () => context.push(AppRoutes.loginPhone)),
        const SizedBox(height: AppDimens.spaceMd),
        SocialLoginRow(onGoogle: comingSoon, onFacebook: comingSoon),
        const SizedBox(height: AppDimens.spaceLg),
        LegalFooter(onTermsTap: comingSoon, onPrivacyTap: comingSoon),
        const SizedBox(height: AppDimens.spaceMd),
      ],
    );
  }
}
