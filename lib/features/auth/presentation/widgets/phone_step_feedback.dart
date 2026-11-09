import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/auth_flow.dart';
import '../auth_routes.dart';
import '../../domain/failures/auth_failure.dart';
import '../mappers/failure_messages.dart';
import '../providers/phone_step_notifier.dart';
import '../providers/phone_step_state.dart';

/// Toasts and navigation driven by phone-step submit status and validation.
final class PhoneStepFeedback {
  PhoneStepFeedback({required this.ref, required this.flow});

  final WidgetRef ref;
  final AuthFlow flow;

  NotifierProvider<PhoneStepNotifier, PhoneStepState> get _provider =>
      phoneStepProvider(flow);

  void warnIfInvalid(BuildContext context) {
    if (!context.mounted) return;
    final error = ref.read(_provider).visibleError;
    if (error == null) return;
    AppToast.show(
      context,
      message: error.message(context.l10n),
      type: AppToastType.error,
    );
  }

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
    final router = GoRouter.of(context);
    final (actionLabel, target) = switch (failure) {
      AuthFailure.notRegistered => (
        context.l10n.registerAction,
        AuthFlow.register,
      ),
      AuthFailure.alreadyRegistered => (context.l10n.logIn, AuthFlow.login),
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
