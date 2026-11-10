import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';

void main() {
  test('onboarding motion tokens match spec', () {
    expect(AppMotion.onboardingHeroEntrance, const Duration(milliseconds: 600));
    expect(AppMotion.onboardingSlide, const Duration(milliseconds: 600));
    expect(AppMotion.onboardingHeroSettledFraction, 0.5);
    expect(AppMotion.onboardingBottomSlideGate, 0.8);
    expect(AppMotion.onboardingHeroStagger, const Duration(milliseconds: 80));
    expect(AppMotion.onboardingIdlePeriod, const Duration(milliseconds: 3500));
    expect(AppMotion.onboardingIdleAmplitude, 6.0);
    expect(AppMotion.onboardingDriftFactor, 0.12);
    expect(AppMotion.onboardingBottomEntrance, const Duration(milliseconds: 500));
    expect(AppMotion.onboardingBottomStagger, const Duration(milliseconds: 60));
    expect(AppMotion.onboardingBottomDelay, const Duration(milliseconds: 200));
    expect(AppMotion.onboardingSlideUp, 16.0);
    expect(AppMotion.welcomeHeroSettledFraction, 0.65);
  });
}
