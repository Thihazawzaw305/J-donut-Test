import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_section.dart';
import 'package:j_donuts_app/features/home/presentation/pages/home_page.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

import '../../../../helpers/catalog_test_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'sections stream error shows retry panels while shops still render',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 2400),
            disableAnimations: true,
          ),
          child: ProviderScope(
            overrides: [
              catalogDatabaseOverride(),
              catalogSectionsProvider.overrideWith(
                (ref) => Stream<List<CatalogSection>>.error(StateError('x')),
              ),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(body: HomePage()),
            ),
          ),
        ),
      );

      for (var i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (tester.any(find.text('Could not load this section.'))) break;
      }

      expect(find.text('Could not load this section.'), findsWidgets);
      expect(find.text('Try again'), findsWidgets);
      expect(find.text('Seasonal specials 💕'), findsOneWidget);
      expect(find.textContaining('J\'Donut shops near you'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    },
  );
}
