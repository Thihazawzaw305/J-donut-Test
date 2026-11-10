import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import 'home_notification_button.dart';

/// Notification pill fixed above scrolling home content (flush right).
class HomePinnedNotification extends StatelessWidget {
  const HomePinnedNotification({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top +
        AppDimens.homeNotificationTopOffset;

    return Positioned(
      top: top,
      right: 0,
      child: HomeNotificationButton(count: count),
    );
  }
}
