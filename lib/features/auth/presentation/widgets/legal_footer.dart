import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class LegalFooter extends StatefulWidget {
  const LegalFooter({
    super.key,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  @override
  State<LegalFooter> createState() => _LegalFooterState();
}

class _LegalFooterState extends State<LegalFooter> {
  late final _termsRecognizer = TapGestureRecognizer()
    ..onTap = () => widget.onTermsTap();
  late final _privacyRecognizer = TapGestureRecognizer()
    ..onTap = () => widget.onPrivacyTap();

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        style: AppTextStyles.caption,
        children: [
          TextSpan(text: l10n.legalNoticePrefix),
          TextSpan(
            text: l10n.termsOfUse,
            style: AppTextStyles.captionLink,
            recognizer: _termsRecognizer,
          ),
          TextSpan(text: l10n.legalNoticeConjunction),
          TextSpan(
            text: l10n.privacyPolicy,
            style: AppTextStyles.captionLink,
            recognizer: _privacyRecognizer,
          ),
          TextSpan(text: l10n.legalNoticeSuffix),
        ],
      ),
    );
  }
}
