import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_text_styles.dart';

/// Stand-in for screens not built yet.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(context.l10n.comingSoon, style: AppTextStyles.body),
      ),
    );
  }
}
