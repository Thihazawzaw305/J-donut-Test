import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/failures/auth_failure.dart';
import '../auth_routes.dart';
import '../mappers/failure_messages.dart';
import '../providers/phone_step_state.dart';

/// Navigation and auth-failure toasts for the phone step (validation is inline).
final class PhoneStepFeedback {
  PhoneStepFeedback({required this.ref, required this.flow});

  final WidgetRef ref;
  final AuthFlow flow;

  void onSubmitStatus(BuildContext context, PhoneSubmitStatus status) {
    if (!context.mounted) return;
    switch (status) {
      case PhoneSubmitSuccess():
        AppToast.hide(context);
        context.push(flow.otpRoute);
      case PhoneSubmitFailure(:final failure):
        _showAuthFailure(context, failure);
      case PhoneSubmitIdle() || PhoneSubmitting():
        break;
    }
  }

  void _showAuthFailure(BuildContext context, AuthFailure failure) {
    if (flow == AuthFlow.login && failure == AuthFailure.notRegistered) {
      return;
    }
    final router = GoRouter.of(context);
    final (actionLabel, target) = switch (failure) {
      AuthFailure.notRegistered => (
        context.l10n.registerAction,
        AuthFlow.register,
      ),
      AuthFailure.alreadyRegistered => (context.l10n.logIn, AuthFlow.login),
      AuthFailure.wrongOtp ||
      AuthFailure.otpLocked => (context.l10n.continueLabel, AuthFlow.login),
    };
    AppToast.show(
      context,
      message: failure.message(context.l10n),
      type: AppToastType.error,
      actionLabel: actionLabel,
      onAction: () => router.pushReplacement(target.phoneRoute),
    );
  }
}
