import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimens.backButtonRadius);
    return Tooltip(
      message: context.l10n.back,
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: const SizedBox.square(
            dimension: AppDimens.backButtonSize,
            child: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: AppDimens.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}
