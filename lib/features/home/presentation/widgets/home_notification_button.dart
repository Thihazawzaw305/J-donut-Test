import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeNotificationButton extends StatelessWidget {
  const HomeNotificationButton({super.key, required this.count});

  final int count;

  static const _stroke = BorderSide(
    color: AppColors.onPrimary,
    width: AppDimens.homeNotificationBorderWidth,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.homeNotificationHeight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppDimens.homeNotificationMinWidth,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.notificationOrange,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimens.homeNotificationRadius),
              bottomLeft: Radius.circular(AppDimens.homeNotificationRadius),
            ),
            border: Border(
              top: _stroke,
              bottom: _stroke,
              left: _stroke,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_none, color: AppColors.onPrimary),
                const SizedBox(width: AppDimens.spaceXs),
                Text(
                  '$count',
                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.onPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
