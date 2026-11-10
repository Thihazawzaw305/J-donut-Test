import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/policies/otp_policy.dart';
import '../mappers/failure_messages.dart';
import '../providers/otp_step_notifier.dart';
import '../providers/otp_step_state.dart';
import 'otp_resend_row.dart';

class OtpStepBody extends StatelessWidget {
  const OtpStepBody({super.key, required this.state, required this.notifier});

  final OtpStepState state;
  final OtpStepNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OtpBoxes(
          digits: state.digits,
          onChanged: notifier.onChanged,
          shakeEpoch: state.shakeEpoch,
          readOnly: state.isSubmitting || state.locked,
          errorText: state.inlineMessage?.message(context.l10n),
        ),
        OtpResendRow(
          remainingSeconds: state.resendRemaining,
          onResend: notifier.resend,
        ),
      ],
    );
  }
}

class OtpBoxes extends StatefulWidget {
  const OtpBoxes({
    super.key,
    required this.digits,
    required this.onChanged,
    required this.shakeEpoch,
    required this.readOnly,
    this.errorText,
  });

  final String digits;
  final ValueChanged<String> onChanged;
  final int shakeEpoch;
  final bool readOnly;
  final String? errorText;

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake;
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(vsync: this, duration: AppMotion.medium);
    _controller = TextEditingController(text: widget.digits);
    _focus = FocusNode()..addListener(_onFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shake.duration = AppMotion.of(context, AppMotion.medium);
  }

  @override
  void didUpdateWidget(OtpBoxes oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController();
    _maybeShake(oldWidget.shakeEpoch);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    _controller.dispose();
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AnimatedBuilder(animation: _shake, builder: _buildShakingBoxes),
            Positioned.fill(child: _buildHiddenField()),
          ],
        ),
        if (widget.errorText != null) _buildError(),
      ],
    );
  }

  Widget _buildShakingBoxes(BuildContext context, Widget? _) {
    final dx = math.sin(_shake.value * math.pi * 6) * AppDimens.spaceSm;
    return Transform.translate(offset: Offset(dx, 0), child: _buildBoxes());
  }

  Widget _buildBoxes() {
    return FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < OtpPolicy.codeLength; i++) ...[
            if (i > 0) const SizedBox(width: AppDimens.otpBoxGap),
            OtpDigitBox(
              digit: i < widget.digits.length ? widget.digits[i] : '',
              showCursor: _shouldShowCursor(i),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHiddenField() {
    return Opacity(
      opacity: 0,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        readOnly: widget.readOnly,
        showCursor: false,
        enableInteractiveSelection: false,
        autofocus: true,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        decoration: const InputDecoration(border: InputBorder.none),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(OtpPolicy.codeLength),
        ],
        onChanged: widget.onChanged,
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceSm),
      child: Text(
        widget.errorText!,
        style: AppTextStyles.body.copyWith(color: AppColors.error),
      ),
    );
  }

  void _onFocus() => setState(() {});

  void _syncController() {
    if (_controller.text == widget.digits) return;
    _controller.value = TextEditingValue(
      text: widget.digits,
      selection: TextSelection.collapsed(offset: widget.digits.length),
    );
  }

  void _maybeShake(int previousEpoch) {
    if (widget.shakeEpoch == previousEpoch || widget.shakeEpoch == 0) return;
    if (MediaQuery.disableAnimationsOf(context)) return;
    _shake.forward(from: 0);
  }

  bool _shouldShowCursor(int index) =>
      _focus.hasFocus &&
      !widget.readOnly &&
      index == widget.digits.length &&
      index < OtpPolicy.codeLength;
}

class OtpDigitBox extends StatelessWidget {
  const OtpDigitBox({super.key, required this.digit, required this.showCursor});

  final String digit;
  final bool showCursor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.otpBoxSize,
      height: AppDimens.otpBoxSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.otpBoxRadius),
      ),
      child: showCursor
          ? Container(
              width: AppDimens.spaceXs / 2,
              height: AppDimens.spaceLg,
              color: AppColors.otpCursor,
            )
          : Text(digit, style: AppTextStyles.input),
    );
  }
}
