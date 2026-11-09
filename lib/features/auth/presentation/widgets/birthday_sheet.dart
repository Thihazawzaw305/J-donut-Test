import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

Future<DateTime?> showBirthdaySheet(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime minimumDate,
  required DateTime maximumDate,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimens.spaceLg),
      ),
    ),
    builder: (_) => BirthdaySheet(
      initialDate: initialDate,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
    ),
  );
}

class BirthdaySheet extends StatefulWidget {
  const BirthdaySheet({
    super.key,
    required this.initialDate,
    required this.minimumDate,
    required this.maximumDate,
  });

  final DateTime initialDate;
  final DateTime minimumDate;
  final DateTime maximumDate;

  @override
  State<BirthdaySheet> createState() => _BirthdaySheetState();
}

class _BirthdaySheetState extends State<BirthdaySheet> {
  late DateTime _selected = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.screenPadding,
          AppDimens.spaceMd,
          AppDimens.screenPadding,
          AppDimens.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(title: l10n.selectBirthday, closeLabel: l10n.close),
            _picker(),
            const SizedBox(height: AppDimens.spaceMd),
            PrimaryButton(
              label: l10n.select,
              onPressed: () => Navigator.of(context).pop(_selected),
            ),
          ],
        ),
      ),
    );
  }

  Widget _picker() {
    return SizedBox(
      height: AppDimens.datePickerHeight,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: widget.initialDate,
        minimumDate: widget.minimumDate,
        maximumDate: widget.maximumDate,
        onDateTimeChanged: (value) => _selected = value,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.closeLabel});

  final String title;
  final String closeLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.headline.copyWith(color: AppColors.accent),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: closeLabel,
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
