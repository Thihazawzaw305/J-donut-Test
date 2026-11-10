import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
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
      value: widget.isLoading ? context.l10n.loading : null,
      onTap: _enabled ? widget.onPressed : null,
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
    // No LayoutBuilder: the button must support intrinsic-height layout
    // (AuthStepScaffold wraps its content in IntrinsicHeight).
    final pill = _AnimatedPill(
      width: isLoading ? AppDimens.buttonHeight : double.infinity,
      duration: duration,
      isDisabled: isDisabled,
      child: _content(),
    );
    if (duration == Duration.zero) {
      return Center(child: pill);
    }
    return Center(
      child: AnimatedSize(
        duration: duration,
        curve: AppMotion.standardCurve,
        child: pill,
      ),
    );
  }

  Widget _content() => AnimatedSwitcher(
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
  );
}

class _AnimatedPill extends StatelessWidget {
  const _AnimatedPill({
    required this.width,
    required this.duration,
    required this.isDisabled,
    required this.child,
  });

  final double width;
  final Duration duration;
  final bool isDisabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: AppDimens.buttonHeight,
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.standardCurve,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.primaryDisabled : AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2),
        ),
        child: child,
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
