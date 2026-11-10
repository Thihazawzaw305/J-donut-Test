import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_coffee_arc_painter.dart';

void main() {
  test('coffee painter repaints when progress changes', () {
    const a = RewardsCoffeeArcPainter(progress: 0.75);
    const b = RewardsCoffeeArcPainter(progress: 0.75);
    const c = RewardsCoffeeArcPainter(progress: 0.25);
    expect(a.shouldRepaint(b), isFalse);
    expect(a.shouldRepaint(c), isTrue);
  });
}
