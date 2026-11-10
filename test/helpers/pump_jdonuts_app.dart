import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/core/router/app_router.dart';
import 'package:j_donuts_app/features/auth/data/datasources/local/session_storage.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/session_providers.dart';

import 'catalog_test_overrides.dart';
import 'in_memory_session_storage.dart';

/// Pumps the real app (router, theme, l10n) and optionally opens [location].
Future<void> pumpJDonutsApp(
  WidgetTester tester, {
  List<Override> overrides = const [],
  String? location,
  Size viewport = const Size(800, 600),
  double textScale = 1.0,
  bool settle = true,
  SessionStorage? sessionStorage,
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: viewport,
        textScaler: TextScaler.linear(textScale),
        disableAnimations: true,
      ),
      child: ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(
            sessionStorage ?? InMemorySessionStorage(),
          ),
          catalogDatabaseOverride(),
          ...overrides,
        ],
        child: const JDonutsApp(),
      ),
    ),
  );
  if (location != null) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(JDonutsApp)),
    );
    container.read(appRouterProvider).go(location);
    await tester.pump();
    await tester.pump(AppMotion.medium);
  } else if (!settle) {
    await tester.pump();
  }
  if (settle) {
    await tester.pump();
    await tester.pump(AppMotion.onboardingSlide);
    await tester.pump(AppMotion.onboardingBottomDelay);
    await tester.pump(AppMotion.onboardingBottomEntrance);
    await tester.pump(AppMotion.onboardingBottomStagger * 6);
  }
}
