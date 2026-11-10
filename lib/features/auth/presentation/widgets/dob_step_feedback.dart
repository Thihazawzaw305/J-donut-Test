import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/validators/phone_validator.dart';
import '../mappers/failure_messages.dart';
import '../providers/auth_draft_notifier.dart';
import '../providers/dob_step_state.dart';
import '../providers/session_notifier.dart';

final class DobStepFeedback {
  DobStepFeedback({required this.ref});

  final WidgetRef ref;

  Future<void> onSubmitStatus(
    BuildContext context,
    DobSubmitStatus status,
  ) async {
    if (!context.mounted) return;
    switch (status) {
      case DobSubmitSuccess():
        AppToast.hide(context);
        final phone =
            validatePhone(ref.read(authDraftProvider).phoneInput).valueOrNull;
        if (phone != null) {
          await ref.read(sessionProvider.notifier).saveActivePhone(phone.e164);
        }
        if (!context.mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          context.go(AppRoutes.welcome);
        });
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
