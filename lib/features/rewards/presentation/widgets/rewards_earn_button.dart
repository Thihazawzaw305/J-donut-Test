import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class RewardsEarnButton extends StatefulWidget {
  const RewardsEarnButton({super.key, required this.enabled});

  final bool enabled;

  @override
  State<RewardsEarnButton> createState() => _RewardsEarnButtonState();
}

class _RewardsEarnButtonState extends State<RewardsEarnButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  var _pressed = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: AppMotion.rewardsEarnPulse,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pulse.duration = AppMotion.of(context, AppMotion.rewardsEarnPulse);
    _syncPulse();
  }

  @override
  void didUpdateWidget(RewardsEarnButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      _syncPulse();
    }
  }

  void _syncPulse() {
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (!widget.enabled || reduce) {
      _pulse.stop();
      _pulse.value = 0;
      return;
    }
    _pulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fill = widget.enabled
        ? AppColors.primary
        : AppColors.rewardsEarnInactive;
    final pressScale = _pressed ? AppMotion.pressedScale : 1.0;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final pulseScale = widget.enabled ? 1 + 0.04 * _pulse.value : 1.0;
        return Transform.scale(scale: pressScale * pulseScale, child: child);
      },
      child: Material(
        color: fill,
        borderRadius: BorderRadius.circular(AppDimens.rewardsEarnRadius),
        child: InkWell(
          onTap: () {},
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          borderRadius: BorderRadius.circular(AppDimens.rewardsEarnRadius),
          child: Container(
            height: AppDimens.rewardsEarnHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.rewardsEarnPaddingH,
            ),
            child: Text(
              context.l10n.rewardsEarn,
              style: AppTextStyles.button.copyWith(
                fontSize: 12,
                letterSpacing: 1.2,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
