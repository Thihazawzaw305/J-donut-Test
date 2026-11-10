import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/connectivity/connectivity_status.dart';
import 'package:j_donuts_app/features/home/presentation/pages/home_page.dart';
import 'package:j_donuts_app/features/home/presentation/providers/home_catalog_refresh_provider.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_offline_banner.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_product_section.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

import '../../../../helpers/catalog_test_overrides.dart';

const _surface = Size(390, 1200);
const _pullStart = Offset(195, 200);
const _pullSteps = 30;
const _pullStepDy = 20.0;

Future<void> _pumpHome(WidgetTester tester, {required bool offline}) async {
  await tester.binding.setSurfaceSize(_surface);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        catalogDatabaseOverride(),
        connectivityOfflineProvider.overrideWith(
          (ref) => Stream.value(offline),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: HomePage()),
      ),
    ),
  );

  for (var i = 0; i < 50; i++) {
    // The in-memory database and asset load complete on real async time.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 100));
    if (tester.any(find.byType(HomeProductSection))) break;
  }
  expect(find.byType(HomeProductSection), findsWidgets);
}

/// Drags the home list down past the refresh trigger and reports whether the
/// pull started a catalog refresh.
Future<bool> _pullDownStartsRefresh(WidgetTester tester) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(HomePage)),
  );
  var refreshStarted = false;
  final subscription = container.listen<bool>(
    homeCatalogRefreshingProvider,
    (_, refreshing) => refreshStarted = refreshStarted || refreshing,
  );

  final gesture = await tester.startGesture(_pullStart);
  for (var i = 0; i < _pullSteps; i++) {
    await gesture.moveBy(const Offset(0, _pullStepDy));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await gesture.up();
  for (var i = 0; i < 40 && !refreshStarted; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }

  subscription.close();
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
  return refreshStarted;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A refresh cut short by teardown can leave a pending cached asset load
  // that would stall the next test's seed read.
  setUp(rootBundle.clear);

  testWidgets('pulling down while online starts a catalog refresh', (
    tester,
  ) async {
    await _pumpHome(tester, offline: false);

    expect(find.byType(HomeOfflineBanner), findsNothing);
    expect(await _pullDownStartsRefresh(tester), isTrue);
  });

  testWidgets('pulling down while offline still starts a catalog refresh', (
    tester,
  ) async {
    await _pumpHome(tester, offline: true);

    expect(find.byType(HomeOfflineBanner), findsOneWidget);
    expect(await _pullDownStartsRefresh(tester), isTrue);
  });
}
