import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/failures/name_validation_failure.dart';
import '../mappers/failure_messages.dart';

class NameFields extends StatelessWidget {
  const NameFields({
    super.key,
    required this.firstController,
    required this.lastController,
    required this.onFirstChanged,
    required this.onLastChanged,
    this.firstError,
    this.lastError,
    this.readOnly = false,
  });

  final TextEditingController firstController;
  final TextEditingController lastController;
  final ValueChanged<String> onFirstChanged;
  final ValueChanged<String> onLastChanged;
  final NameValidationFailure? firstError;
  final NameValidationFailure? lastError;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NameTextField(
          controller: firstController,
          hintText: l10n.firstNameHint,
          errorText: firstError?.message(l10n, isFirstName: true),
          autofillHints: const [AutofillHints.givenName],
          textInputAction: TextInputAction.next,
          readOnly: readOnly,
          onChanged: onFirstChanged,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        NameTextField(
          controller: lastController,
          hintText: l10n.lastNameHint,
          errorText: lastError?.message(l10n, isFirstName: false),
          autofillHints: const [AutofillHints.familyName],
          textInputAction: TextInputAction.done,
          readOnly: readOnly,
          onChanged: onLastChanged,
        ),
      ],
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.textInputAction,
    required this.autofillHints,
    this.errorText,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;
  final Iterable<String> autofillHints;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _field(),
        if (errorText != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            errorText!,
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _field() {
    return Container(
      constraints: const BoxConstraints(minHeight: AppDimens.inputHeight),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        textCapitalization: TextCapitalization.words,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        style: AppTextStyles.input,
        decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: AppTextStyles.inputHint,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
