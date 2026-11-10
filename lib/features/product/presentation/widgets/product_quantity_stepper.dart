import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProductQuantityStepper extends StatelessWidget {
  const ProductQuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.quantityTrack,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            tooltip: context.l10n.quantityDecrease,
            icon: Icons.remove,
            onTap: onDecrease,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
            child: AnimatedSwitcher(
              duration: AppMotion.of(context, AppMotion.short),
              switchInCurve: AppMotion.standardCurve,
              switchOutCurve: AppMotion.standardCurve,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                '$quantity',
                key: ValueKey<int>(quantity),
                style: AppTextStyles.headline.copyWith(fontSize: 22),
              ),
            ),
          ),
          _StepButton(
            tooltip: context.l10n.quantityIncrease,
            icon: Icons.add,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      iconSize: AppDimens.iconMd,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
      ),
      icon: Icon(icon),
    );
  }
}
