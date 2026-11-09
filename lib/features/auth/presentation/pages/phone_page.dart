import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/validators/phone_input_normalizer.dart';
import '../providers/phone_step_notifier.dart';
import '../providers/phone_step_state.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/phone_input_field.dart';
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

  NotifierProvider<PhoneStepNotifier, PhoneStepState> get _provider =>
      phoneStepProvider(widget.flow);

  PhoneStepFeedback get _feedback =>
      PhoneStepFeedback(ref: ref, flow: widget.flow);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: normalizePhoneInputForDisplay(ref.read(_provider).input),
    );
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
    ref.listen(
      _provider.select((s) => s.status),
      (_, status) => _feedback.onSubmitStatus(context, status),
    );
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
    if (!mounted) return;
    final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
    if (!_focusNode.hasFocus && isCurrentRoute) {
      _feedback.warnIfInvalid(context);
    }
  }

  void _onKeyboardDone(PhoneStepState state) => state.canSubmit
      ? ref.read(_provider.notifier).submit()
      : _feedback.warnIfInvalid(context);

  void _goBack() =>
      context.canPop() ? context.pop() : context.go(AppRoutes.onboarding);
}
