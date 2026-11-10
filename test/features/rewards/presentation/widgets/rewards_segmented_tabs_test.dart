import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_segmented_tabs.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('eat pill selected uses cyan fill and white label', (
    tester,
  ) async {
    await tester.pumpApp(
      RewardsSegmentedTabs(giftSelected: false, onGiftSelected: (_) {}),
    );
    await tester.pumpAndSettle();

    final thumb = tester.widget<AnimatedContainer>(
      find.byKey(const Key('rewards_tab_thumb')),
    );
    final decoration = thumb.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.primary);
    final eatText = tester.widget<Text>(find.text('Eat more earn more'));
    expect(eatText.style?.color, AppColors.onPrimary);
  });

  testWidgets('gift pill unselected uses whitish fill and dark label', (
    tester,
  ) async {
    await tester.pumpApp(
      RewardsSegmentedTabs(giftSelected: false, onGiftSelected: (_) {}),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('rewards_tab_thumb')), findsOneWidget);
    final giftText = tester.widget<Text>(find.text('Gift'));
    expect(giftText.style?.color, AppColors.textPrimary);
  });

  testWidgets('pills hug label width instead of stretching full row', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpApp(
      RewardsSegmentedTabs(giftSelected: false, onGiftSelected: (_) {}),
    );
    await tester.pumpAndSettle();

    final eat = tester.getSize(find.byKey(const Key('rewards_tab_eat_hit')));
    final gift = tester.getSize(find.byKey(const Key('rewards_tab_gift_hit')));
    expect(gift.width, lessThan(eat.width));
    expect(eat.width, lessThan(300));
    expect(gift.width, lessThan(120));
  });
}
