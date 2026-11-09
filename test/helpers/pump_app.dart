import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/theme/app_theme.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
  /// Pumps [child] inside a themed, localized app with a Scaffold.
  Future<void> pumpApp(Widget child) => pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}
