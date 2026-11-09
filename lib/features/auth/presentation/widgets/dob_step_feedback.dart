import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../mappers/failure_messages.dart';
import '../providers/dob_step_state.dart';

final class DobStepFeedback {
  const DobStepFeedback();

  void onSubmitStatus(BuildContext context, DobSubmitStatus status) {
    if (!context.mounted) return;
    switch (status) {
      case DobSubmitSuccess():
        AppToast.hide(context);
        // Terminal Welcome: `go` drops Phone→OTP→Name→DOB so Back cannot
        // resubmit DOB. Until Welcome, register still uses `push`.
        context.go(AppRoutes.welcome);
      case DobSubmitFailure(:final failure):
        AppToast.show(
          context,
          message: failure.message(context.l10n),
          type: AppToastType.error,
        );
      case DobSubmitIdle() || DobSubmitting():
        break;
    }
  }
}
