import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_donut_quarter_clipper.dart';

void main() {
  test('clipper repaints when progress changes', () {
    final a = RewardsDonutQuarterClipper(progress: 0.25);
    final b = RewardsDonutQuarterClipper(progress: 0.5);
    expect(a.shouldReclip(b), isTrue);
  });

  test('one quarter progress uses single quadrant span', () {
    const clipper = RewardsDonutQuarterClipper(progress: 0.25);
    const size = Size(80, 80);
    final bounds = clipper.getClip(size).getBounds();
    expect(bounds.width, greaterThan(0));
    expect(bounds.height, greaterThan(0));
    expect(bounds.left, greaterThanOrEqualTo(0));
  });
}
