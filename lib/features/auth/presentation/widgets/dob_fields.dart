import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/policies/age_policy.dart';
import '../mappers/failure_messages.dart';
import '../providers/auth_providers.dart';
import '../providers/dob_step_notifier.dart';
import '../providers/dob_step_state.dart';
import 'birthday_sheet.dart';

class DobFields extends ConsumerWidget {
  const DobFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(dobStepProvider);
    final error = _visibleError(context, state);
    Future<void> open() => _openSheet(context, ref, state);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DobReadOnlyField(
          hint: l10n.dayHint,
          value: state.day?.toString(),
          onTap: state.isSubmitting ? null : open,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        _DobReadOnlyField(
          hint: l10n.monthHint,
          value: _monthLabel(context, state.month),
          onTap: state.isSubmitting ? null : open,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        _DobReadOnlyField(
          hint: l10n.yearHint,
          value: state.year?.toString(),
          onTap: state.isSubmitting ? null : open,
        ),
        if (error != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            error,
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

String? _monthLabel(BuildContext context, int? month) {
  if (month == null) return null;
  return DateFormat.MMMM(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(DateTime(2000, month));
}

String? _visibleError(BuildContext context, DobStepState state) {
  final hasAnyPart =
      state.year != null || state.month != null || state.day != null;
  if (!hasAnyPart) return null;
  return state.visibleError?.message(context.l10n);
}

Future<void> _openSheet(
  BuildContext context,
  WidgetRef ref,
  DobStepState state,
) async {
  if (state.isSubmitting) return;
  final now = ref.read(clockProvider)();
  final today = DateTime(now.year, now.month, now.day);
  final minimum = DateTime(
    today.year - AgePolicy.maxAgeYears,
    today.month,
    today.day,
  );
  final picked = await showBirthdaySheet(
    context,
    initialDate: _initialDate(state, today, minimum),
    minimumDate: minimum,
    maximumDate: today,
  );
  if (picked == null || !context.mounted) return;
  ref
      .read(dobStepProvider.notifier)
      .onDateChanged(year: picked.year, month: picked.month, day: picked.day);
}

DateTime _initialDate(DobStepState state, DateTime today, DateTime minimum) {
  if (state.year == null || state.month == null || state.day == null) {
    return DateTime(today.year - AgePolicy.minAgeYears, today.month, today.day);
  }
  final value = DateTime(state.year!, state.month!, state.day!);
  if (value.isBefore(minimum)) return minimum;
  if (value.isAfter(today)) return today;
  return value;
}

class _DobReadOnlyField extends StatelessWidget {
  const _DobReadOnlyField({
    required this.hint,
    required this.value,
    required this.onTap,
  });

  final String hint;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.inputHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.inputRadius),
        ),
        child: IgnorePointer(
          child: TextFormField(
            key: ValueKey('$hint-${value ?? ''}'),
            initialValue: value ?? '',
            readOnly: true,
            style: AppTextStyles.input,
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: AppTextStyles.inputHint,
            ),
          ),
        ),
      ),
    );
  }
}
