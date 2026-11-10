import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/auth_flow.dart';
import '../providers/phone_step_notifier.dart';
import '../providers/phone_step_state.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/phone_step_body.dart';
import '../widgets/phone_step_feedback.dart';

class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key, required this.flow});

  final AuthFlow flow;

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  var _showValidationMessage = false;

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
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedback = PhoneStepFeedback(ref: ref, flow: widget.flow);
    ref.listen(
      _provider.select((s) => s.status),
      (_, status) => feedback.onSubmitStatus(context, status),
    );
    ref.listen(_provider.select((s) => s.input), (prev, next) {
      if (_controller.text != next) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
    });
    final state = ref.watch(_provider);
    final notifier = ref.read(_provider.notifier);
    return AuthStepScaffold(
      title: context.l10n.phoneTitle,
      currentStep: widget.flow == AuthFlow.register ? 1 : null,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go(AppRoutes.onboarding),
      body: PhoneStepBody(
        flow: widget.flow,
        state: state,
        controller: _controller,
        focusNode: _focusNode,
        showValidationMessage: _showValidationMessage,
        onChanged: (value) {
          if (_showValidationMessage) {
            setState(() => _showValidationMessage = false);
          }
          notifier.onInputChanged(value);
        },
        onSubmitted: (_) => _onKeyboardDone(state),
        onRegisterTap: () => context.pushReplacement(AppRoutes.registerPhone),
      ),
      action: PrimaryButton(
        label: context.l10n.continueLabel,
        isLoading: state.isSubmitting,
        onPressed: state.canSubmit ? notifier.submit : null,
      ),
    );
  }

  void _onFocusChanged() {
    if (!mounted) return;
    final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
    if (!_focusNode.hasFocus && isCurrentRoute && ref.read(_provider).visibleError != null) {
      setState(() => _showValidationMessage = true);
    }
  }

  void _onKeyboardDone(PhoneStepState state) {
    if (state.canSubmit) {
      ref.read(_provider.notifier).submit();
      return;
    }
    if (state.visibleError != null) {
      setState(() => _showValidationMessage = true);
    }
  }
}
