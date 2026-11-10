import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/session_notifier.dart';
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      physics: AppMotion.homeScrollPhysics(context),
      padding: const EdgeInsets.fromLTRB(
        AppDimens.screenPadding,
        AppDimens.screenPadding,
        AppDimens.screenPadding,
        AppDimens.screenPadding,
      ),
      children: [
        Text(
          context.l10n.settingsTitle,
          style: AppTextStyles.headline,
        ),
        ListTile(
          title: Text(context.l10n.logOut, style: AppTextStyles.body),
          onTap: () async {
            await ref.read(sessionProvider.notifier).logout();
            if (context.mounted) context.go(AppRoutes.onboarding);
          },
        ),
      ],
    );
  }
}
