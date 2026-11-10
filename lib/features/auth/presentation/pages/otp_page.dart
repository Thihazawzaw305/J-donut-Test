import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/validators/phone_validator.dart';
import '../auth_routes.dart';
import '../providers/auth_draft_notifier.dart';
import '../providers/otp_step_notifier.dart';
import '../providers/otp_step_state.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/otp_boxes.dart';
import '../widgets/otp_step_feedback.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key, required this.flow});

  final AuthFlow flow;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  Timer? _ticker;

  NotifierProvider<OtpStepNotifier, OtpStepState> get _provider =>
      otpStepProvider(widget.flow);

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) ref.read(_provider.notifier).tick();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_provider.select((s) => s.status), (_, status) async {
      if (status is OtpSubmitSuccess) _ticker?.cancel();
      await OtpStepFeedback(
        ref: ref,
        flow: widget.flow,
      ).onSubmitStatus(context, status);
    });
    final state = ref.watch(_provider);
    final e164 =
        validatePhone(
          ref.watch(authDraftProvider).phoneInput,
        ).valueOrNull?.e164 ??
        '';
    return AuthStepScaffold(
      title: context.l10n.verifyNumberTitle,
      subtitle: context.l10n.otpSentTo(e164),
      currentStep: widget.flow == AuthFlow.register ? 2 : null,
      onBack: () =>
          context.canPop() ? context.pop() : context.go(widget.flow.phoneRoute),
      body: OtpStepBody(state: state, notifier: ref.read(_provider.notifier)),
    );
  }
}
