import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/core/router/app_router.dart';

/// Pumps the real app (router, theme, l10n) and optionally opens [location].
Future<void> pumpJDonutsApp(
  WidgetTester tester, {
  List<Override> overrides = const [],
  String? location,
  Size viewport = const Size(800, 600),
  double textScale = 1.0,
  bool settle = true,
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: viewport,
        textScaler: TextScaler.linear(textScale),
      ),
      child: ProviderScope(overrides: overrides, child: const JDonutsApp()),
    ),
  );
  if (location != null) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(JDonutsApp)),
    );
    container.read(appRouterProvider).go(location);
  }
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}
