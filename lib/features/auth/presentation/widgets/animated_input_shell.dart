import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';

/// White input pill whose border animates on focus and error.
class AnimatedInputShell extends StatefulWidget {
  const AnimatedInputShell({
    super.key,
    required this.child,
    this.hasError = false,
    this.height,
    this.alignment,
  });

  final Widget child;
  final bool hasError;

  /// Fixed height; when null the pill is at least [AppDimens.inputHeight].
  final double? height;
  final AlignmentGeometry? alignment;

  @override
  State<AnimatedInputShell> createState() => _AnimatedInputShellState();
}

class _AnimatedInputShellState extends State<AnimatedInputShell> {
  bool _focused = false;

  Color get _borderColor {
    if (widget.hasError) return AppColors.error;
    return _focused ? AppColors.inputBorderFocused : AppColors.inputBorderIdle;
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.short),
        curve: AppMotion.standardCurve,
        constraints: height == null
            ? const BoxConstraints(minHeight: AppDimens.inputHeight)
            : BoxConstraints.tightFor(height: height),
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
        alignment: widget.alignment,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.inputRadius),
          border: Border.all(
            color: _borderColor,
            width: AppDimens.inputBorderWidth,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
