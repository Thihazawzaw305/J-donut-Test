# Welcome hero Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Full-bleed donut collage on post-registration Welcome with gradient fade, headline, and Let's explore CTA per spec.

**Architecture:** Static `WelcomeHeroImage` (0.65 viewport band) + reused `OnboardingHeroGradientOverlay` in a `Stack`; existing l10n and routing unchanged. TDD: widget tests before widgets.

**Tech Stack:** Flutter 3.12+, gen-l10n, existing `AppAssets` / `AppMotion` patterns.

## Global Constraints

- No new pub dependencies.
- Strings/colors from l10n and theme tokens only.
- `welcomeHeroSettledFraction` = **0.65**.
- Asset path: `assets/images/welcome_hero.jpg`.

---

### Task 1: Motion constant + asset plumbing

**Files:**
- Modify: `lib/core/constants/app_motion.dart`
- Modify: `lib/core/constants/app_assets.dart`
- Modify: `pubspec.yaml`
- Add: `assets/images/welcome_hero.jpg`
- Test: `test/core/constants/app_motion_test.dart`

- [ ] **Step 1:** Add failing expect for `welcomeHeroSettledFraction == 0.65`
- [ ] **Step 2:** Run `flutter test test/core/constants/app_motion_test.dart` — FAIL
- [ ] **Step 3:** Add constant + `AppAssets.welcomeHero` + pubspec + copy image
- [ ] **Step 4:** Run test — PASS

### Task 2: WelcomeHeroImage

**Files:**
- Create: `lib/features/auth/presentation/widgets/welcome_hero_image.dart`
- Test: `test/features/auth/presentation/widgets/welcome_hero_image_test.dart`

- [ ] **Step 1:** Test hero height = 0.65 × viewport at key `welcome_hero_image`
- [ ] **Step 2:** Run test — FAIL
- [ ] **Step 3:** Implement widget (mirror onboarding hero, no slide)
- [ ] **Step 4:** Run test — PASS

### Task 3: WelcomePage layout

**Files:**
- Modify: `lib/features/auth/presentation/pages/welcome_page.dart`
- Test: `test/features/auth/presentation/pages/welcome_page_test.dart`

- [ ] **Step 1:** Test headline, `LET'S EXPLORE`, hero key, gradient overlay key
- [ ] **Step 2:** Run test — FAIL
- [ ] **Step 3:** Stack layout with overlay + bottom column
- [ ] **Step 4:** Run `flutter test test/features/auth/presentation/pages/welcome_page_test.dart` — PASS
- [ ] **Step 5:** Run `flutter test` + `flutter analyze`
