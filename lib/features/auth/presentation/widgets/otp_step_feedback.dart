import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/validators/phone_validator.dart';
import '../auth_routes.dart';
import '../mappers/failure_messages.dart';
import '../providers/auth_draft_notifier.dart';
import '../providers/otp_step_state.dart';
import '../providers/session_notifier.dart';

final class OtpStepFeedback {
  OtpStepFeedback({required this.ref, required this.flow});

  final WidgetRef ref;
  final AuthFlow flow;

  Future<void> onSubmitStatus(
    BuildContext context,
    OtpSubmitStatus status,
  ) async {
    if (!context.mounted) return;
    switch (status) {
      case OtpSubmitSuccess():
        AppToast.hide(context);
        await _onSuccess(context);
      case OtpSubmitFailure(:final failure):
        _onFailure(context, failure);
      case OtpSubmitIdle() || OtpSubmitting():
        break;
    }
  }

  Future<void> _onSuccess(BuildContext context) async {
    final phone = validatePhone(
      ref.read(authDraftProvider).phoneInput,
    ).valueOrNull;
    if (phone != null) {
      await ref.read(sessionProvider.notifier).saveActivePhone(phone.e164);
    }
    if (!context.mounted) return;
    switch (flow) {
      case AuthFlow.register:
        context.push(flow.nameRoute);
      case AuthFlow.login:
        context.go(AppRoutes.home);
    }
  }

  void _onFailure(BuildContext context, AuthFailure failure) {
    if (failure == AuthFailure.wrongOtp || failure == AuthFailure.otpLocked) {
      return;
    }
    final target = switch (failure) {
      AuthFailure.notRegistered => AuthFlow.register,
      AuthFailure.alreadyRegistered => AuthFlow.login,
      AuthFailure.wrongOtp || AuthFailure.otpLocked => flow,
    };
    final actionLabel = switch (failure) {
      AuthFailure.notRegistered => context.l10n.registerAction,
      AuthFailure.alreadyRegistered => context.l10n.logIn,
      AuthFailure.wrongOtp ||
      AuthFailure.otpLocked => context.l10n.continueLabel,
    };
    AppToast.show(
      context,
      message: failure.message(context.l10n),
      type: AppToastType.error,
      actionLabel: actionLabel,
      onAction: () => GoRouter.of(context).pushReplacement(target.phoneRoute),
    );
  }
}
