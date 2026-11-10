import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class RewardsSegmentedTabs extends StatefulWidget {
  const RewardsSegmentedTabs({super.key});

  @override
  State<RewardsSegmentedTabs> createState() => _RewardsSegmentedTabsState();
}

class _RewardsSegmentedTabsState extends State<RewardsSegmentedTabs> {
  var _giftSelected = false;

  @override
  Widget build(BuildContext context) {
    final eatLabel = context.l10n.rewardsEatMoreEarnMore;
    final giftLabel = context.l10n.rewardsGiftTab;
    final duration = AppMotion.of(context, AppMotion.rewardsTabThumb);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.rewardsSegmentedMaxWidth),
          child: Material(
            color: AppColors.quantityTrack,
            borderRadius: BorderRadius.circular(AppDimens.rewardsSegmentedThumbRadius),
            child: SizedBox(
              height: AppDimens.rewardsSegmentedBarHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final thumbWidth = constraints.maxWidth / 2;
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: duration,
                        curve: AppMotion.standardCurve,
                        left: _giftSelected ? thumbWidth : 0,
                        top: 4,
                        bottom: 4,
                        width: thumbWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                AppDimens.rewardsSegmentedThumbRadius,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _TabHit(
                            label: eatLabel,
                            selected: !_giftSelected,
                            onTap: () => setState(() => _giftSelected = false),
                          ),
                          _TabHit(
                            label: giftLabel,
                            selected: _giftSelected,
                            onTap: () => setState(() => _giftSelected = true),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabHit extends StatelessWidget {
  const _TabHit({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.rewardsSegmentedThumbRadius),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodyBold.copyWith(
                color: selected ? AppColors.onPrimary : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
