import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class RewardsSegmentedTabs extends StatelessWidget {
  const RewardsSegmentedTabs({
    super.key,
    required this.giftSelected,
    required this.onGiftSelected,
  });

  final bool giftSelected;
  final ValueChanged<bool> onGiftSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: UnconstrainedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
        children: [
          _RewardsSegmentPill(
            containerKey: const Key('rewards_tab_eat'),
            label: context.l10n.rewardsEatMoreEarnMore,
            selected: !giftSelected,
            paddingH: AppDimens.rewardsSegmentedEatPaddingH,
            onTap: () => onGiftSelected(false),
          ),
          const SizedBox(width: AppDimens.rewardsSegmentedGap),
          _RewardsSegmentPill(
            containerKey: const Key('rewards_tab_gift'),
            label: context.l10n.rewardsGiftTab,
            selected: giftSelected,
            paddingH: AppDimens.rewardsSegmentedGiftPaddingH,
            onTap: () => onGiftSelected(true),
          ),
        ],
        ),
      ),
    );
  }
}

class _RewardsSegmentPill extends StatefulWidget {
  const _RewardsSegmentPill({
    required this.containerKey,
    required this.label,
    required this.selected,
    required this.paddingH,
    required this.onTap,
  });

  final Key containerKey;
  final String label;
  final bool selected;
  final double paddingH;
  final VoidCallback onTap;

  @override
  State<_RewardsSegmentPill> createState() => _RewardsSegmentPillState();
}

class _RewardsSegmentPillState extends State<_RewardsSegmentPill> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.rewardsTabThumb);
    final scale = _pressed ? 0.97 : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: AppMotion.standardCurve,
      child: AnimatedContainer(
        key: widget.containerKey,
        duration: duration,
        curve: AppMotion.standardCurve,
        height: AppDimens.rewardsSegmentedBarHeight,
        decoration: BoxDecoration(
          color: widget.selected
              ? AppColors.primary
              : AppColors.rewardsSegmentedUnselected,
          borderRadius: BorderRadius.circular(
            AppDimens.rewardsSegmentedThumbRadius,
          ),
          border: Border.all(
            color: AppColors.onPrimary,
            width: AppDimens.rewardsSegmentedBorderWidth,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            borderRadius: BorderRadius.circular(
              AppDimens.rewardsSegmentedThumbRadius,
            ),
            child: Container(
              height: AppDimens.rewardsSegmentedBarHeight,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: widget.paddingH),
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold.copyWith(
                  color: widget.selected
                      ? AppColors.onPrimary
                      : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
