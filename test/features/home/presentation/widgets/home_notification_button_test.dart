import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_notification_button.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('uses compact height and thin white border on three sides', (
    tester,
  ) async {
    await tester.pumpApp(const HomeNotificationButton(count: 2));

    final box = tester.getSize(find.byType(HomeNotificationButton));
    expect(box.height, AppDimens.homeNotificationHeight);

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(HomeNotificationButton),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    final border = decorated.decoration as BoxDecoration;
    expect(border.border, isA<Border>());
    final edges = border.border as Border;
    expect(edges.top.width, AppDimens.homeNotificationBorderWidth);
    expect(edges.top.color, AppColors.onPrimary);
    expect(edges.right, BorderSide.none);
    expect(
      border.borderRadius,
      const BorderRadius.only(
        topLeft: Radius.circular(AppDimens.homeNotificationRadius),
        bottomLeft: Radius.circular(AppDimens.homeNotificationRadius),
      ),
    );
  });
}
