# Onboarding hero motion + headline stagger

Date: 2026-11-09  
Scope: Onboarding screen only — floating hero entrance, idle loop, headline copy, bottom block stagger.  
Reference: user screen recording (6.2s); code test §6 Onboarding row.

## Goals

- Match Madivizion motion: **donut circles drift in**; **title and buttons enter staggered**.
- Add localized headline **"Round food for every mood"** above CTAs.
- After entrance, **idle float** on hero circles (desynced sine), like reference clip.
- Keep **color circle placeholders**; real donut/logo PNGs drop in later without changing motion API.
- Respect **Reduce Motion** via existing `AppMotion.of`.
- **60 fps** target; motion only via Flutter animation APIs + `AppMotion` constants (no Rive/Lottie for this slice).

## Non-goals

- Real 3D donut assets, bitten pink logo disk, or Rive file.
- Changes to phone/OTP routes, auth logic, or social integration.
- New pub dependencies (`flutter_animate`, etc.).

## Motion tokens (add to `AppMotion`)

| Token | Value | Use |
|---|---|---|
| `onboardingHeroEntrance` | 600 ms | Total hero drift-in timeline |
| `onboardingHeroStagger` | 80 ms | Delay between each circle |
| `onboardingBottomEntrance` | 500 ms | Bottom block fade/slide window |
| `onboardingBottomStagger` | 60 ms | Delay between headline → CTA children |
| `onboardingBottomDelay` | 200 ms | Start after hero entrance begins |
| `onboardingIdlePeriod` | 3500 ms | Sine float loop period |
| `onboardingIdleAmplitude` | 6.0 (logical px) | Vertical bob |
| `onboardingDriftFactor` | 0.12 | Start offset as fraction of hero extent |
| `onboardingSlideUp` | 16.0 (logical px) | Bottom entrance translate |

Curves: `standardCurve` (`easeOutCubic`) for entrance; idle uses linear time → sine.

**Reduce Motion:** `AppMotion.of(context, duration)` returns zero → hero and bottom snap to final layout; idle listener not started.

## UI structure

```
OnboardingPage
├── GradientBackground
│   └── SafeArea
│       └── Column
│           ├── Expanded → OnboardingHero (Stateful, 1 controller entrance + 1 repeat idle)
│           └── OnboardingBottomEntrance (new, wraps existing bottom Column)
│               ├── Text(onboardingHeadline)  // AppTextStyles.headline, centered
│               ├── PrimaryButton, LoginPrompt, SocialLoginRow, LegalFooter (unchanged behavior)
```

### OnboardingHero behavior

- Five placeholder circles keep current layout anchors; each animates:
  - **Entrance:** `opacity` 0→1, `offset` from outward direction (based on `Alignment` sign) × `driftFactor × extent`, to 0.
  - **Stagger:** circle index × `onboardingHeroStagger` on parent controller 0→1.
- **Idle:** after entrance `status == completed`, `repeat()` on secondary controller 0→1 mapping to `sin(2πt + phase)` per circle; fixed phases (seeded, not random) for stability in tests.
- Logo circle: same entrance/idle as others (still placeholder).

### OnboardingBottomEntrance

- Single `AnimationController` (duration = bottom entrance + stagger × childCount).
- Each child: `FadeTransition` + `SlideTransition` from `Offset(0, slideUp/viewportFraction)` with staggered `Interval`.
- Children order: headline, button column contents in current order.

## Localization

- `app_en.arb`: key `onboardingHeadline`, value `Round food for every mood`.
- Widget: `context.l10n.onboardingHeadline`.

## Testing (TDD)

1. **`onboarding_hero_test.dart`**
   - Pump hero with animations disabled → all circles visible (find by semantics or `OnboardingHero` structure).
   - Pump with animations enabled: initial frame circles may be off-screen/low opacity; after `pump(onboardingHeroEntrance + stagger)` expect stable layout without exceptions.

2. **`onboarding_page_test.dart`**
   - Expect `onboardingHeadline` text present after settle.
   - Narrow viewport + `textScale` 1.3 still passes (existing test).
   - Optional: `pumpJDonutsApp(..., settle: false)` then pump durations — headline appears before or with button (stagger order).

3. Run `flutter test` for auth onboarding paths; `flutter analyze` clean.

## Dependencies / files

| File | Action |
|---|---|
| `lib/core/constants/app_motion.dart` | Add onboarding constants |
| `lib/l10n/app_en.arb` | Add headline |
| `lib/features/auth/presentation/widgets/onboarding_hero.dart` | Stateful + animations |
| `lib/features/auth/presentation/widgets/onboarding_bottom_entrance.dart` | Create |
| `lib/features/auth/presentation/pages/onboarding_page.dart` | Wire headline + entrance wrapper |
| `test/.../onboarding_hero_test.dart` | Create |
| `test/.../onboarding_page_test.dart` | Extend |

## Acceptance

- Visual: circles drift in, then gentle bob; headline and CTAs stagger in.
- Reduce Motion: instant static onboarding.
- No new analyzer issues; existing onboarding navigation tests still pass.
