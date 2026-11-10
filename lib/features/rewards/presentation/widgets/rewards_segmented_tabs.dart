import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class RewardsSegmentedTabs extends StatefulWidget {
  const RewardsSegmentedTabs({
    super.key,
    required this.giftSelected,
    required this.onGiftSelected,
  });

  final bool giftSelected;
  final ValueChanged<bool> onGiftSelected;

  @override
  State<RewardsSegmentedTabs> createState() => _RewardsSegmentedTabsState();
}

class _RewardsSegmentedTabsState extends State<RewardsSegmentedTabs> {
  final GlobalKey _eatKey = GlobalKey();
  final GlobalKey _giftKey = GlobalKey();
  double _eatWidth = 0;
  double _giftWidth = 0;
  var _laidOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _remeasure());
  }

  @override
  void didUpdateWidget(covariant RewardsSegmentedTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _remeasure());
  }

  void _remeasure() {
    final eat = _eatKey.currentContext?.findRenderObject() as RenderBox?;
    final gift = _giftKey.currentContext?.findRenderObject() as RenderBox?;
    if (eat == null || gift == null) return;
    final ew = eat.size.width;
    final gw = gift.size.width;
    if (ew == _eatWidth && gw == _giftWidth && _laidOut) return;
    setState(() {
      _eatWidth = ew;
      _giftWidth = gw;
      _laidOut = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.rewardsTabThumb);
    final thumbLeft = widget.giftSelected
        ? _eatWidth + AppDimens.rewardsSegmentedGap
        : 0.0;
    final thumbWidth = widget.giftSelected ? _giftWidth : _eatWidth;

    return Align(
      alignment: Alignment.center,
      child: UnconstrainedBox(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (_laidOut && thumbWidth > 0)
              Positioned(
                left: thumbLeft,
                width: thumbWidth,
                height: AppDimens.rewardsSegmentedBarHeight,
                child: AnimatedContainer(
                  key: const Key('rewards_tab_thumb'),
                  duration: duration,
                  curve: AppMotion.standardCurve,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(
                      AppDimens.rewardsSegmentedThumbRadius,
                    ),
                    border: Border.all(
                      color: AppColors.onPrimary,
                      width: AppDimens.rewardsSegmentedBorderWidth,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RewardsSegmentHitTarget(
                  measureKey: _eatKey,
                  containerKey: const Key('rewards_tab_eat_hit'),
                  label: context.l10n.rewardsEatMoreEarnMore,
                  selected: !widget.giftSelected,
                  paddingH: AppDimens.rewardsSegmentedEatPaddingH,
                  onTap: () => widget.onGiftSelected(false),
                ),
                const SizedBox(width: AppDimens.rewardsSegmentedGap),
                _RewardsSegmentHitTarget(
                  measureKey: _giftKey,
                  containerKey: const Key('rewards_tab_gift_hit'),
                  label: context.l10n.rewardsGiftTab,
                  selected: widget.giftSelected,
                  paddingH: AppDimens.rewardsSegmentedGiftPaddingH,
                  onTap: () => widget.onGiftSelected(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardsSegmentHitTarget extends StatefulWidget {
  const _RewardsSegmentHitTarget({
    required this.measureKey,
    required this.containerKey,
    required this.label,
    required this.selected,
    required this.paddingH,
    required this.onTap,
  });

  final GlobalKey measureKey;
  final Key containerKey;
  final String label;
  final bool selected;
  final double paddingH;
  final VoidCallback onTap;

  @override
  State<_RewardsSegmentHitTarget> createState() =>
      _RewardsSegmentHitTargetState();
}

class _RewardsSegmentHitTargetState extends State<_RewardsSegmentHitTarget> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.rewardsTabThumb);
    final scale = _pressed ? 0.97 : 1.0;
    final labelColor = widget.selected
        ? AppColors.onPrimary
        : AppColors.textPrimary;

    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: AppMotion.standardCurve,
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
          child: AnimatedContainer(
            key: widget.measureKey,
            duration: duration,
            curve: AppMotion.standardCurve,
            height: AppDimens.rewardsSegmentedBarHeight,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: widget.paddingH),
            decoration: BoxDecoration(
              color: widget.selected
                  ? Colors.transparent
                  : AppColors.rewardsSegmentedUnselected,
              borderRadius: BorderRadius.circular(
                AppDimens.rewardsSegmentedThumbRadius,
              ),
              border: Border.all(
                color: AppColors.onPrimary,
                width: AppDimens.rewardsSegmentedBorderWidth,
              ),
            ),
            child: Text(
              widget.label,
              key: widget.containerKey,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyBold.copyWith(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
