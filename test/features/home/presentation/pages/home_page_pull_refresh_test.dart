import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/home/presentation/pages/home_page.dart';
import 'package:j_donuts_app/features/home/presentation/providers/home_catalog_refresh_provider.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_product_section.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_product_section_skeleton.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

import '../../../../helpers/catalog_test_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('homeCatalogRefreshing shows section skeletons not live rows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(390, 1200),
          disableAnimations: true,
        ),
        child: ProviderScope(
          overrides: [catalogDatabaseOverride()],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: HomePage()),
          ),
        ),
      ),
    );

    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (tester.any(find.byType(HomeProductSection))) break;
    }
    expect(find.byType(HomeProductSection), findsWidgets);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(HomePage)),
    );
    container.read(homeCatalogRefreshingProvider.notifier).setRefreshing(true);
    await tester.pump();

    expect(find.byType(HomeProductSectionSkeleton), findsWidgets);
    expect(find.byType(HomeProductSection), findsNothing);

    container.read(homeCatalogRefreshingProvider.notifier).setRefreshing(false);
    await tester.pump();

    expect(find.byType(HomeProductSection), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
