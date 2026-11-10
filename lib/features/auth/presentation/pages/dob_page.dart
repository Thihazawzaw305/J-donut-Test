import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/dob_step_notifier.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/dob_fields.dart';
import '../widgets/dob_step_feedback.dart';

class DobPage extends ConsumerWidget {
  const DobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      dobStepProvider.select((s) => s.status),
      (_, status) => DobStepFeedback(ref: ref).onSubmitStatus(context, status),
    );
    final state = ref.watch(dobStepProvider);
    final notifier = ref.read(dobStepProvider.notifier);
    return AuthStepScaffold(
      title: context.l10n.dobTitle,
      currentStep: 4,
      showCheck: true,
      onBack: () => _goBack(context),
      body: const DobFields(),
      action: PrimaryButton(
        label: context.l10n.continueLabel,
        isLoading: state.isSubmitting,
        onPressed: state.validation.isOk ? notifier.submit : null,
      ),
    );
  }
}

void _goBack(BuildContext context) =>
    context.canPop() ? context.pop() : context.go(AppRoutes.registerName);
