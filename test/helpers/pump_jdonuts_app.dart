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
}) async {
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, child: const JDonutsApp()),
  );
  if (location != null) {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(JDonutsApp)));
    container.read(appRouterProvider).go(location);
  }
  await tester.pumpAndSettle();
}
