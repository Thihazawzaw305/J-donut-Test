import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';

/// Google, Apple, and Facebook placeholder sign-in buttons.
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({
    super.key,
    required this.onGoogle,
    required this.onApple,
    required this.onFacebook,
  });

  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final VoidCallback onFacebook;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          tooltip: context.l10n.continueWithGoogle,
          icon: Icons.g_mobiledata_rounded,
          iconColor: AppColors.textPrimary,
          onTap: onGoogle,
        ),
        const SizedBox(width: AppDimens.spaceLg),
        _SocialButton(
          tooltip: context.l10n.continueWithApple,
          icon: Icons.apple,
          iconColor: AppColors.textPrimary,
          onTap: onApple,
        ),
        const SizedBox(width: AppDimens.spaceLg),
        _SocialButton(
          tooltip: context.l10n.continueWithFacebook,
          icon: Icons.facebook,
          iconColor: AppColors.facebookBlue,
          onTap: onFacebook,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.tooltip,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        elevation: AppDimens.socialButtonElevation,
        shadowColor: AppColors.shadow,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: AppDimens.socialButtonSize,
            child: Icon(icon, color: iconColor, size: AppDimens.iconLg),
          ),
        ),
      ),
    );
  }
}
