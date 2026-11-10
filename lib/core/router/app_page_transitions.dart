import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_motion.dart';

abstract final class AppPageTransitions {
  static Page<void> page({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    SharedAxisTransitionType sharedAxis = SharedAxisTransitionType.horizontal,
    bool fadeThrough = false,
  }) {
    final duration = AppMotion.of(context, AppMotion.medium);
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.disableAnimationsOf(context)) return child;

        if (fadeThrough) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        }

        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: sharedAxis,
          child: child,
        );
      },
    );
  }
}
