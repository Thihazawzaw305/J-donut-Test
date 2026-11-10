import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_donut_ring_painter.dart';

void main() {
  test('RewardsDonutRingPainter repaints when progress changes', () {
    final a = RewardsDonutRingPainter(progress: 0);
    final b = RewardsDonutRingPainter(progress: 0.5);
    expect(a.shouldRepaint(b), isTrue);
  });
}
