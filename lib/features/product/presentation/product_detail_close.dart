import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Closes product detail with the correct reverse transition.
///
/// [OpenContainer] from home pushes a navigator route — use [Navigator.pop].
/// Deep links via go_router fall back to [GoRouter.pop] when needed.
void closeProductDetail(BuildContext context) {
  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
    return;
  }
  if (context.canPop()) {
    context.pop();
  }
}
