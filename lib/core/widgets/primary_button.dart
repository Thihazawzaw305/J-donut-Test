import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_motion.dart';
import '../theme/app_text_styles.dart';

/// Pill button that scales on press and morphs into a spinner while loading.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _setPressed(bool pressed) {
    if (_pressed != pressed) setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.medium);
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: () => _setPressed(false),
        onTap: _enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed ? AppMotion.pressedScale : 1,
          duration: AppMotion.of(context, AppMotion.short),
          child: _ButtonBody(
            label: widget.label,
            isLoading: widget.isLoading,
            isDisabled: widget.onPressed == null && !widget.isLoading,
            duration: duration,
          ),
        ),
      ),
    );
  }
}

class _ButtonBody extends StatelessWidget {
  const _ButtonBody({
    required this.label,
    required this.isLoading,
    required this.isDisabled,
    required this.duration,
  });

  final String label;
  final bool isLoading;
  final bool isDisabled;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: AnimatedContainer(
          duration: duration,
          curve: AppMotion.standardCurve,
          height: AppDimens.buttonHeight,
          width: isLoading ? AppDimens.buttonHeight : constraints.maxWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDisabled ? AppColors.primaryDisabled : AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2),
          ),
          child: AnimatedSwitcher(
            duration: duration,
            child: isLoading
                ? const _Spinner()
                : Text(
                    label.toUpperCase(),
                    key: ValueKey(label),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: AppTextStyles.button,
                  ),
          ),
        ),
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: AppDimens.spinnerSize,
      child: CircularProgressIndicator(
        strokeWidth: AppDimens.spinnerStroke,
        color: AppColors.onPrimary,
      ),
    );
  }
}
