import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/onboarding_donut_slots.dart';

void main() {
  test('defines five tiles: one center, two left, two right', () {
    expect(onboardingDonutTiles, hasLength(5));
    expect(onboardingDonutTiles.where((t) => t.dx == 0), hasLength(1));
    expect(onboardingDonutTiles.where((t) => t.dx < 0), hasLength(2));
    expect(onboardingDonutTiles.where((t) => t.dx > 0), hasLength(2));
  });

  test('side tiles are partly cropped by the screen edge', () {
    for (final t in onboardingDonutTiles.where((t) => t.dx != 0)) {
      expect(t.dx.abs() + t.size / 2, greaterThan(0.5));
      expect(t.dx.abs() - t.size / 2, lessThan(0.5));
    }
  });

  test('center tile is fully on screen', () {
    final center = onboardingDonutTiles.firstWhere((t) => t.dx == 0);
    expect(center.size / 2, lessThan(0.5));
  });

  test('group does not move at progress 0', () {
    expect(onboardingGroupOffset(0), 0);
  });

  test('group moves up by the full shift at progress 1', () {
    expect(onboardingGroupOffset(1), onboardingGroupShift);
    expect(onboardingGroupShift, lessThan(0));
  });

  test('group moves monotonically upward', () {
    var previous = onboardingGroupOffset(0);
    for (var p = 0.1; p <= 1.0; p += 0.1) {
      final current = onboardingGroupOffset(p);
      expect(current, lessThanOrEqualTo(previous));
      previous = current;
    }
  });

  test('logo fades out then back in around the move', () {
    expect(onboardingLogoOpacity(0), 1);
    expect(onboardingLogoOpacity(0.5), 0);
    expect(onboardingLogoOpacity(1), 1);
  });

  test('logo drifts from start to end position', () {
    expect(onboardingLogoDy(0), onboardingLogoStartDy);
    expect(onboardingLogoDy(1), onboardingLogoEndDy);
  });
}
