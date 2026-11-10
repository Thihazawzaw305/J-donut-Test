import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/rewards/domain/rewards_tier.dart';

void main() {
  test('tierFromCode maps silver', () {
    expect(tierFromCode('silver'), RewardsTier.silver);
  });

  test('silver member has reached silver not gold', () {
    expect(isTierReached('silver', RewardsTier.silver), isTrue);
    expect(isTierReached('silver', RewardsTier.gold), isFalse);
  });
}
