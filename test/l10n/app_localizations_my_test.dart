import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/theme/app_theme.dart';
import 'package:j_donuts_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

const _burmese = Locale('my');

void main() {
  test('Burmese is a supported locale', () {
    expect(AppLocalizations.supportedLocales, contains(_burmese));
  });

  test('Burmese strings differ from the English template', () {
    final my = lookupAppLocalizations(_burmese);
    final en = lookupAppLocalizations(const Locale('en'));

    expect(my.logOut, isNot(en.logOut));
    expect(my.continueLabel, isNot(en.continueLabel));
    expect(my.homeShopsNearby(4), contains('4'));
  });

  test('untranslated product names fall back to English', () {
    final my = lookupAppLocalizations(_burmese);

    expect(my.productCoconutDonut, 'Coconut Donut');
  });

  testWidgets('welcome page renders in Burmese without layout errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: _burmese,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: WelcomePage()),
      ),
    );
    await tester.pumpAndSettle();

    final my = lookupAppLocalizations(_burmese);
    expect(find.text(my.letsExplore), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
