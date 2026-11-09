import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/failures/auth_failure.dart';
import '../auth_routes.dart';
import '../mappers/failure_messages.dart';
import '../providers/otp_step_state.dart';

final class OtpStepFeedback {
  OtpStepFeedback({required this.flow});

  final AuthFlow flow;

  void onSubmitStatus(BuildContext context, OtpSubmitStatus status) {
    if (!context.mounted) return;
    switch (status) {
      case OtpSubmitSuccess():
        AppToast.hide(context);
        context.push(_successRoute);
      case OtpSubmitFailure(:final failure):
        _onFailure(context, failure);
      case OtpSubmitIdle() || OtpSubmitting():
        break;
    }
  }

  String get _successRoute => switch (flow) {
    AuthFlow.register => AppRoutes.registerName,
    AuthFlow.login => AppRoutes.home,
  };

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
      AuthFailure.wrongOtp || AuthFailure.otpLocked => context.l10n.continueLabel,
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
