import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/rewards/domain/rewards_challenge.dart';

void main() {
  test('complete when current meets total', () {
    expect(
      challengeIsComplete(current: 4, total: 4),
      isTrue,
    );
    expect(
      challengeIsComplete(current: 1, total: 4),
      isFalse,
    );
  });

  test('progress fraction matches quarters and cups', () {
    expect(challengeProgressFraction(current: 1, total: 4), 0.25);
    expect(challengeProgressFraction(current: 4, total: 4), 1);
    expect(challengeProgressFraction(current: 9, total: 12), 0.75);
  });

  test('earn is enabled only when complete', () {
    expect(challengeEarnEnabled(current: 4, total: 4), isTrue);
    expect(challengeEarnEnabled(current: 9, total: 12), isFalse);
  });
}
