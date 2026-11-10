import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';
import 'package:j_donuts_app/features/rewards/presentation/rewards_entrance_values.dart';

void main() {
  test('entrance start hides every element and offsets it fully', () {
    final values = RewardsEntranceValues.at(0, reduceMotion: false);

    expect(values.progress, 0);
    expect(values.tierFades, [0.0, 0.0, 0.0]);
    expect(values.tierSlides, everyElement(AppMotion.rewardsEntranceOffset));
    expect(values.sideFade, 0);
    expect(values.sideSlide, AppMotion.rewardsEntranceOffset);
    expect(values.titleFade, 0);
    expect(values.titleSlide, AppMotion.rewardsEntranceOffset);
  });

  test('entrance end shows every element at rest', () {
    final values = RewardsEntranceValues.at(1, reduceMotion: false);

    expect(values.progress, 1);
    expect(values.tierFades, [1.0, 1.0, 1.0]);
    expect(values.tierSlides, [0.0, 0.0, 0.0]);
    expect(values.sideFade, 1);
    expect(values.sideSlide, 0);
    expect(values.titleFade, 1);
    expect(values.titleSlide, 0);
  });

  test('tiers appear in order while entrance is mid-way', () {
    final values = RewardsEntranceValues.at(0.3, reduceMotion: false);

    expect(values.tierFades[0], greaterThan(values.tierFades[1]));
    expect(values.tierFades[1], greaterThan(values.tierFades[2]));
  });

  test('reduce motion returns the settled state at any time', () {
    final values = RewardsEntranceValues.at(0, reduceMotion: true);

    expect(values.progress, 1);
    expect(values.tierFades, [1.0, 1.0, 1.0]);
    expect(values.tierSlides, [0.0, 0.0, 0.0]);
    expect(values.sideFade, 1);
    expect(values.titleSlide, 0);
  });

  test('badge scale grows from rest scale to full size', () {
    expect(rewardsBadgeScale(0), AppMotion.rewardsBadgeRestScale);
    expect(rewardsBadgeScale(1), 1);
  });
}
