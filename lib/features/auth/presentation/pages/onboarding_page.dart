import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.onboardingPadding),
          child: PrimaryButton(
            label: context.l10n.getStarted,
            onPressed: () => context.push(AppRoutes.registerPhone),
          ),
        ),
      ),
    );
  }
}
