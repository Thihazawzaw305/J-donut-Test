import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 300);
  static const long = Duration(milliseconds: 600);
  static const toastDisplay = Duration(seconds: 3);

  static const standardCurve = Curves.easeOutCubic;
  static const pressedScale = 0.96;

  /// [duration], or zero when the user asked to reduce motion.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
