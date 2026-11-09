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
    final time = '$mm : $ss';
    final formatted = context.l10n.otpResendIn(mm, ss);
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.otpResendPrompt, style: AppTextStyles.body),
          const SizedBox(height: AppDimens.spaceXs),
          GestureDetector(
            onTap: remainingSeconds == 0 ? onResend : null,
            child: Text.rich(_resendSpans(formatted, time)),
          ),
        ],
      ),
    );
  }
}

TextSpan _resendSpans(String formatted, String time) {
  final index = formatted.indexOf(time);
  if (index < 0) {
    return TextSpan(text: formatted, style: AppTextStyles.body);
  }
  return TextSpan(
    style: AppTextStyles.body,
    children: [
      TextSpan(text: formatted.substring(0, index)),
      TextSpan(text: time, style: AppTextStyles.link),
      TextSpan(text: formatted.substring(index + time.length)),
    ],
  );
}
