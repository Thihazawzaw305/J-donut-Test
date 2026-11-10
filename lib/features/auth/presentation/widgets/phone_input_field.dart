import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/phone_number.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    this.readOnly = false,
  });

  static const _maxInputLength = 15;
  static final _allowedCharacters = RegExp(r'[0-9 +\-]');

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppDimens.inputHeight),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      ),
      child: Row(
        children: [
          const Text(PhoneNumber.countryCode, style: AppTextStyles.inputHint),
          const SizedBox(width: AppDimens.spaceLg),
          Expanded(child: _buildTextField(context)),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [
        FilteringTextInputFormatter.allow(_allowedCharacters),
        LengthLimitingTextInputFormatter(_maxInputLength),
      ],
      style: AppTextStyles.input,
      decoration: InputDecoration.collapsed(
        hintText: context.l10n.phoneHint,
        hintStyle: AppTextStyles.inputHint,
      ),
      onTapOutside: (_) => focusNode.unfocus(),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
