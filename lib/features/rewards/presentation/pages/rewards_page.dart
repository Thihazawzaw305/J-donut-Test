import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/placeholder_page.dart';
class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: context.l10n.rewardsTitle);
  }
}
