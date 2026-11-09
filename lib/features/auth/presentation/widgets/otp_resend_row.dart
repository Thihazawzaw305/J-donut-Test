import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class OtpResendRow extends StatelessWidget {
  const OtpResendRow({
    super.key,
    required this.remainingSeconds,
    required this.onResend,
  });

  final int remainingSeconds;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final mm = '${remainingSeconds ~/ 60}';
    final ss = (remainingSeconds % 60).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceXl),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(context.l10n.otpResendPrompt, style: AppTextStyles.body),
          const SizedBox(width: AppDimens.spaceXs),
          GestureDetector(
            onTap: remainingSeconds == 0 ? onResend : null,
            child: Text(
              context.l10n.otpResendIn(mm, ss),
              style: AppTextStyles.link,
            ),
          ),
        ],
      ),
    );
  }
}
