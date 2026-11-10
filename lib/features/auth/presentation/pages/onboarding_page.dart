import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/legal_footer.dart';
import '../widgets/login_prompt.dart';
import '../widgets/onboarding_bottom_entrance.dart';
import '../widgets/onboarding_hero_gradient_overlay.dart';
import '../widgets/onboarding_hero_image.dart';
import '../widgets/social_login_row.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  final _bottomKey = GlobalKey<OnboardingBottomEntranceState>();
  bool _bottomStarted = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: AppMotion.onboardingSlide,
    )..addListener(_onSlideProgress);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = AppMotion.of(context, AppMotion.onboardingSlide);
    _slideController.duration = duration;
    if (duration == Duration.zero) {
      _slideController.value = 1;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _bottomKey.currentState?.beginEntrance();
      });
    } else if (_slideController.status == AnimationStatus.dismissed) {
      _slideController.forward();
    }
  }

  void _onSlideProgress() {
    if (_bottomStarted) return;
    if (_slideController.value < AppMotion.onboardingBottomSlideGate) return;
    _bottomStarted = true;
    _bottomKey.currentState?.beginEntrance();
  }

  @override
  void dispose() {
    _slideController
      ..removeListener(_onSlideProgress)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: OnboardingHeroImage(slideProgress: _slideController),
          ),
          const OnboardingHeroGradientOverlay(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.onboardingPadding,
                  ),
                  child: _buildActions(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    void comingSoon() =>
        AppToast.show(context, message: context.l10n.comingSoon);

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return OnboardingBottomEntrance(
      key: _bottomKey,
      autoStart: reduceMotion,
      children: [
        Text(
          context.l10n.onboardingHeadline,
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        PrimaryButton(
          label: context.l10n.getStarted,
          onPressed: () => context.push(AppRoutes.registerPhone),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        LoginPrompt(onLogIn: () => context.push(AppRoutes.loginPhone)),
        const SizedBox(height: AppDimens.spaceMd),
        SocialLoginRow(
          onGoogle: comingSoon,
          onApple: comingSoon,
          onFacebook: comingSoon,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        LegalFooter(onTermsTap: comingSoon, onPrivacyTap: comingSoon),
        const SizedBox(height: AppDimens.spaceMd),
      ],
    );
  }
}
