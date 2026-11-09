import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_motion.dart';
import '../theme/app_text_styles.dart';

enum AppToastType { info, error }

/// Short floating message; replaces any toast already on screen.
abstract final class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final action = actionLabel == null
        ? null
        : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppMotion.toastDisplay,
          content: _ToastContent(message: message, type: type),
          action: action,
        ),
      );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({required this.message, required this.type});

  final String message;
  final AppToastType type;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      AppToastType.info => (Icons.info_rounded, AppColors.primary),
      AppToastType.error => (Icons.error_rounded, AppColors.error),
    };
    return Row(
      children: [
        Icon(icon, color: color, size: AppDimens.iconMd),
        const SizedBox(width: AppDimens.spaceSm),
        Expanded(child: Text(message, style: AppTextStyles.toast)),
      ],
    );
  }
}
