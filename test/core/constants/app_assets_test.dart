import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_assets.dart';

void main() {
  test('onboarding hero asset path is registered', () {
    expect(AppAssets.onboardingHero, 'assets/images/onboarding_hero.jpg');
  });

  test('home refresh donut asset path is registered', () {
    expect(
      AppAssets.homeRefreshDonut,
      'assets/images/home_refresh_donut.png',
    );
  });

  test('home shops background asset path is registered', () {
    expect(
      AppAssets.homeShopsBackground,
      'assets/images/home_shops_background.jpg',
    );
  });

  test('home shops grass overlay asset path is registered', () {
    expect(
      AppAssets.homeShopsGrassOverlay,
      'assets/images/home_shops_grass_overlay.png',
    );
  });
}
