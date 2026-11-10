# Welcome screen — full-bleed donut hero

Date: 2026-11-09  
Scope: Post-registration `WelcomePage` only — hero imagery, gradient fade, existing copy/CTA layout matching the J'donuts welcome mockup shell.  
Reference: user glossy donut collage (3×2 grid); welcome mockup (headline + cyan CTA on soft panel).

## Goals

- Top **~65%** of screen shows **full-bleed** donut collage (`BoxFit.cover`, top-aligned).
- **Gradient overlay** fades hero into `AppColors.backgroundBottom` so headline and button match mockup readability.
- Keep existing l10n: `welcomeHeadline`, `letsExplore`; navigation `AppRoutes.home` unchanged.
- **Static hero** (no slide-in); route transition remains app-wide `FadeThrough` for welcome.
- Respect **Reduce Motion** — layout identical (hero already static).
- **TDD:** widget tests before production widgets.

## Non-goals

- Onboarding layout/motion changes (`OnboardingPage`, `OnboardingHeroImage` slide).
- Masonry 2×2 cards with patterned backgrounds (user chose full-bleed).
- Login, social, or legal blocks on welcome.
- New pub dependencies.

## UI structure

```
WelcomePage
└── Stack (fit: expand)
    ├── WelcomeHeroImage          // Key: welcome_hero_image
    ├── OnboardingHeroGradientOverlay
    └── SafeArea (top: false)
        └── Padding (horizontal: AppDimens.screenPadding)
            └── Column (stretch)
                ├── Spacer
                ├── Text(welcomeHeadline)     // AppTextStyles.headline, center
                ├── SizedBox(spaceLg)
                ├── PrimaryButton(letsExplore)  // → context.go(home)
                └── SizedBox(spaceXl)
```

### WelcomeHeroImage

- `SizedBox` height = `viewportHeight * welcomeHeroSettledFraction` (**0.65** — taller hero than onboarding’s `0.5` to match welcome mockup).
- `ClipRect` + `Image.asset(AppAssets.welcomeHero, fit: BoxFit.cover, width: full, height: viewportHeight)`.
- Optional `alignment: Alignment(0, -0.15)` if default crop clips donuts — tune once asset is in repo.
- `errorBuilder`: solid `AppColors.backgroundBottom` (no crash if asset missing in test without override).

### Gradient

- Reuse `OnboardingHeroGradientOverlay` (pink/white stops → `AppColors.backgroundBottom`).
- Full-screen `Positioned.fill` or `Stack` child after hero, before foreground column.

## Assets

| Item | Path |
|------|------|
| Source | User file: glossy donut 3×2 collage |
| Bundled | `assets/images/welcome_hero.jpg` (or `.png` if transparency required) |
| Constant | `AppAssets.welcomeHero` |
| pubspec | Add under `flutter.assets` |

## Motion tokens

| Token | Value | Use |
|-------|-------|-----|
| `welcomeHeroSettledFraction` | `0.65` | Hero band height as fraction of viewport |

Add to `app_motion.dart` (or `app_dimens.dart` if project keeps hero fractions there — prefer same file as `onboardingHeroSettledFraction` if present).

## Localization

No new ARB keys.

## Testing (TDD)

1. **`welcome_page_test.dart`** (create first — must fail before widgets exist)
   - Pump `WelcomePage` with `MaterialApp` / test harness used elsewhere.
   - Expect `find.text` matching `welcomeHeadline` and `letsExplore` (use gen-l10n or fixture locale).
   - Expect `find.byKey(Key('welcome_hero_image'))`.
   - Optionally: `Image` descendant with asset name containing `welcome_hero`.

2. **`auth_navigation_test.dart`**
   - Existing register path → welcome: still finds welcome headline (no regression).

3. **Layout**
   - Narrow viewport width 320 + `textScaleFactor: 1.3`: no overflow (scroll or flex — wrap bottom in `SingleChildScrollView` only if test fails).

4. Verify: `flutter test test/features/auth/presentation/pages/welcome_page_test.dart`; full auth tests; `flutter analyze`.

## Files

| File | Action |
|------|--------|
| `assets/images/welcome_hero.jpg` | Add (from user collage) |
| `pubspec.yaml` | Register asset |
| `lib/core/constants/app_assets.dart` | `welcomeHero` |
| `lib/core/constants/app_motion.dart` | `welcomeHeroSettledFraction` if not duplicated |
| `lib/features/auth/presentation/widgets/welcome_hero_image.dart` | Create |
| `lib/features/auth/presentation/pages/welcome_page.dart` | Stack layout |
| `test/features/auth/presentation/pages/welcome_page_test.dart` | Create (RED first) |

## Acceptance

- Visual: donut collage dominant on top; soft fade to panel; centered headline; full-width primary button at bottom (mockup shell).
- Functional: Let's explore → home; registration flow still lands on welcome.
- Tests green; analyzer clean.
