import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/failures/auth_failure.dart';
import '../auth_routes.dart';
import '../mappers/failure_messages.dart';
import '../providers/phone_step_notifier.dart';
import '../providers/phone_step_state.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/phone_input_field.dart';

class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key, required this.flow});

  final AuthFlow flow;

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  NotifierProvider<PhoneStepNotifier, PhoneStepState> get _provider =>
      phoneStepProvider(widget.flow);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(_provider).input);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_provider.select((s) => s.status), (_, s) => _onStatus(s));
    final state = ref.watch(_provider);
    final notifier = ref.read(_provider.notifier);
    return AuthStepScaffold(
      title: context.l10n.phoneTitle,
      currentStep: widget.flow == AuthFlow.register ? 1 : null,
      onBack: _goBack,
      body: PhoneInputField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: state.isSubmitting,
        onChanged: notifier.onInputChanged,
        onSubmitted: (_) => _onKeyboardDone(state),
      ),
      action: PrimaryButton(
        label: context.l10n.continueLabel,
        isLoading: state.isSubmitting,
        onPressed: state.canSubmit ? notifier.submit : null,
      ),
    );
  }

  void _onFocusChanged() {
    final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
    if (!_focusNode.hasFocus && isCurrentRoute) _warnIfInvalid();
  }

  void _onKeyboardDone(PhoneStepState state) => state.canSubmit
      ? ref.read(_provider.notifier).submit()
      : _warnIfInvalid();

  void _warnIfInvalid() {
    final error = ref.read(_provider).visibleError;
    if (error == null) return;
    AppToast.show(
      context,
      message: error.message(context.l10n),
      type: AppToastType.error,
    );
  }

  void _onStatus(PhoneSubmitStatus status) {
    switch (status) {
      case PhoneSubmitSuccess():
        context.push(widget.flow.otpRoute);
      case PhoneSubmitFailure(:final failure):
        _showAuthFailure(failure);
      case PhoneSubmitIdle() || PhoneSubmitting():
        break;
    }
  }

  void _showAuthFailure(AuthFailure failure) {
    final router = GoRouter.of(context);
    final (actionLabel, target) = switch (failure) {
      AuthFailure.notRegistered => (context.l10n.registerAction, AuthFlow.register),
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

  void _goBack() =>
      context.canPop() ? context.pop() : context.go(AppRoutes.onboarding);
}
