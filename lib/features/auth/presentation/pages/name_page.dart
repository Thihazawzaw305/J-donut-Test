import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/name_step_notifier.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/name_fields.dart';
import '../widgets/name_step_feedback.dart';

class NamePage extends ConsumerStatefulWidget {
  const NamePage({super.key});

  @override
  ConsumerState<NamePage> createState() => _NamePageState();
}

class _NamePageState extends ConsumerState<NamePage> {
  late final TextEditingController _first;
  late final TextEditingController _last;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(nameStepProvider);
    _first = TextEditingController(text: draft.firstName);
    _last = TextEditingController(text: draft.lastName);
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      nameStepProvider.select((s) => s.status),
      (_, status) => const NameStepFeedback().onSubmitStatus(context, status),
    );
    final state = ref.watch(nameStepProvider);
    final notifier = ref.read(nameStepProvider.notifier);
    return AuthStepScaffold(
      title: context.l10n.nameTitle,
      currentStep: 3,
      onBack: _goBack,
      body: NameFields(
        firstController: _first,
        lastController: _last,
        onFirstChanged: notifier.onFirstNameChanged,
        onLastChanged: notifier.onLastNameChanged,
        firstError: state.visibleFirstError,
        lastError: state.visibleLastError,
        readOnly: state.isSubmitting,
      ),
      action: PrimaryButton(
        label: context.l10n.continueLabel,
        isLoading: state.isSubmitting,
        onPressed: state.canSubmit ? notifier.submit : null,
      ),
    );
  }

  void _goBack() =>
      context.canPop() ? context.pop() : context.go(AppRoutes.registerOtp);
}
