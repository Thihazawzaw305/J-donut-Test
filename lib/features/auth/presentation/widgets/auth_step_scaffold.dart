import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/gradient_background.dart';
import 'auth_back_button.dart';
import 'legal_footer.dart';
import 'step_progress_ring.dart';

/// Shared layout of every auth step: header, title, body, action, legal.
class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    super.key,
    required this.title,
    required this.body,
    this.action,
    required this.onBack,
    this.currentStep,
    this.showCheck = false,
  });

  static const registrationStepCount = 4;

  final String title;
  final Widget body;
  final Widget? action;
  final VoidCallback onBack;

  /// Registration step (1-based); null hides the progress ring.
  final int? currentStep;
  final bool showCheck;

  void _showComingSoon(BuildContext context) =>
      AppToast.show(context, message: context.l10n.comingSoon);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(child: _buildContent(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        _buildTitle(context),
        body,
        const Spacer(),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final step = currentStep;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.spaceLg),
        Row(
          children: [
            TextFieldTapRegion(child: AuthBackButton(onPressed: onBack)),
            const Spacer(),
            if (step != null)
              StepProgressRing(
                currentStep: step,
                totalSteps: registrationStepCount,
                showCheck: showCheck,
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXl),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppTextStyles.headline),
        const SizedBox(height: AppDimens.spaceXl),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.spaceLg),
        if (action != null) ...[
          action!,
          const SizedBox(height: AppDimens.spaceLg),
        ],
        LegalFooter(
          onTermsTap: () => _showComingSoon(context),
          onPrivacyTap: () => _showComingSoon(context),
        ),
        const SizedBox(height: AppDimens.spaceMd),
      ],
    );
  }
}
