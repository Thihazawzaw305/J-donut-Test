import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/failures/auth_failure.dart';
import '../mappers/failure_messages.dart';
import '../providers/phone_step_state.dart';
import 'phone_input_field.dart';

class PhoneStepBody extends StatelessWidget {
  const PhoneStepBody({
    super.key,
    required this.flow,
    required this.state,
    required this.controller,
    required this.focusNode,
    required this.showValidationMessage,
    required this.onChanged,
    required this.onSubmitted,
    required this.onRegisterTap,
  });

  final AuthFlow flow;
  final PhoneStepState state;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showValidationMessage;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    final validationMessage = _validationMessage(context);
    final authMessage = _authInline(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PhoneInputField(
          controller: controller,
          focusNode: focusNode,
          readOnly: state.isSubmitting,
          hasError: validationMessage != null,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
        if (validationMessage != null) ...[
          const SizedBox(height: AppDimens.spaceSm),
          Text(validationMessage, style: AppTextStyles.error),
        ],
        if (authMessage != null) ...[
          const SizedBox(height: AppDimens.spaceSm),
          authMessage,
        ],
      ],
    );
  }

  String? _validationMessage(BuildContext context) {
    if (!showValidationMessage) return null;
    final failure = state.visibleError;
    return failure?.message(context.l10n);
  }

  Widget? _authInline(BuildContext context) {
    final status = state.status;
    if (status is! PhoneSubmitFailure) return null;
    if (status.failure != AuthFailure.notRegistered || flow != AuthFlow.login) {
      return null;
    }
    final l10n = context.l10n;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppDimens.spaceXs,
      children: [
        Text(status.failure.message(l10n), style: AppTextStyles.error),
        GestureDetector(
          onTap: onRegisterTap,
          child: Text(l10n.registerAction, style: AppTextStyles.link),
        ),
      ],
    );
  }
}
