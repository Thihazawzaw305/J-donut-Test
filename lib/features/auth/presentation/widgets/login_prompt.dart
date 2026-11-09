import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key, required this.onLogIn});

  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(l10n.alreadyHaveAccount, style: AppTextStyles.body),
        TextButton(
          onPressed: onLogIn,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
          ),
          child: Text(l10n.logIn, style: AppTextStyles.link),
        ),
      ],
    );
  }
}
