import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/auth_flow.dart';
import '../auth_routes.dart';
import '../mappers/failure_messages.dart';
import '../providers/name_step_state.dart';

final class NameStepFeedback {
  const NameStepFeedback();

  void onSubmitStatus(BuildContext context, NameSubmitStatus status) {
    if (!context.mounted) return;
    switch (status) {
      case NameSubmitSuccess():
        AppToast.hide(context);
        context.push(AuthFlow.register.dobRoute);
      case NameSubmitFailure(:final failure):
        AppToast.show(
          context,
          message: failure.message(context.l10n),
          type: AppToastType.error,
        );
      case NameSubmitIdle() || NameSubmitting():
        break;
    }
  }
}
