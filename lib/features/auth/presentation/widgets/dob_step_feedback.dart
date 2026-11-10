import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/catalog_providers.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/format_member_display_name.dart';
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
        final draft = ref.read(authDraftProvider);
        final phone = validatePhone(draft.phoneInput).valueOrNull;
        final displayName = formatMemberDisplayName(
          firstName: draft.firstName,
          lastName: draft.lastName,
        );
        if (displayName.isNotEmpty) {
          await ref.read(databaseProvider.future);
          await ref
              .read(catalogRepositoryProvider)
              .updateMemberDisplayName(displayName);
        }
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
