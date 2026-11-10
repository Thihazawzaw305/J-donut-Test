import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/rewards/presentation/rewards_tab_strip_layout.dart';

void main() {
  test('tab strip centers on the white panel bottom seam', () {
    const whiteHeight = 420.0;
    final top = rewardsTabStripTop(whiteHeight);
    final center = top + AppDimens.rewardsSegmentedBarHeight / 2;
    expect(center, closeTo(whiteHeight, 0.001));
  });
}
