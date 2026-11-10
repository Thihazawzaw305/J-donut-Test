import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class RewardsErrorBody extends StatelessWidget {
  const RewardsErrorBody({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            const SizedBox(height: AppDimens.spaceMd),
            TextButton(onPressed: onRetry, child: Text(context.l10n.homeRetry)),
          ],
        ),
      ),
    );
  }
}
