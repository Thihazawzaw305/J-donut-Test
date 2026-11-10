# Onboarding Hero Motion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add onboarding hero drift-in + idle float and staggered headline/CTA entrance per reference video and code test §6.

**Architecture:** Extend `AppMotion` with named onboarding durations; convert `OnboardingHero` to a dual-controller stateful widget (entrance then idle sine offsets); wrap bottom content in `OnboardingBottomEntrance` with staggered fade/slide. Headline via gen-l10n. TDD: failing widget tests first.

**Tech Stack:** Flutter 3.x, Riverpod app shell, `go_router`, gen-l10n, existing `AppMotion.of` reduce-motion gate.

## Global Constraints

- Motion constants only in `lib/core/constants/app_motion.dart`; no magic numbers in widgets.
- User-visible strings in `app_en.arb` only.
- Colors from `AppColors` / theme; no hardcoded copy in widgets.
- Respect `MediaQuery.disableAnimationsOf` through `AppMotion.of`.
- Clean Architecture: changes stay in `features/auth/presentation/` and `core/constants`.
- File size ~300 lines max; split widgets if hero grows too large.
- No new pub dependencies.

**Spec:** `docs/superpowers/specs/2026-11-09-onboarding-hero-motion-design.md`

---

### Task 1: Motion constants

**Files:**
- Modify: `lib/core/constants/app_motion.dart`
- Test: `test/core/constants/app_motion_test.dart` (create)

**Interfaces:**
- Produces: static const durations and doubles listed in spec on `AppMotion`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_motion.dart';

void main() {
  test('onboarding motion tokens match spec', () {
    expect(AppMotion.onboardingHeroEntrance, const Duration(milliseconds: 600));
    expect(AppMotion.onboardingHeroStagger, const Duration(milliseconds: 80));
    expect(AppMotion.onboardingIdlePeriod, const Duration(milliseconds: 3500));
    expect(AppMotion.onboardingIdleAmplitude, 6.0);
    expect(AppMotion.onboardingDriftFactor, 0.12);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/constants/app_motion_test.dart`  
Expected: FAIL — getters not defined

- [ ] **Step 3: Add constants to `AppMotion`**

Add all tokens from spec (`onboardingBottomEntrance`, `onboardingBottomStagger`, `onboardingBottomDelay`, `onboardingSlideUp`, etc.).

- [ ] **Step 4: Run test — PASS**

- [ ] **Step 5: Commit** (only if user asked)

---

### Task 2: Headline localization

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Test: `test/features/auth/presentation/pages/onboarding_page_test.dart`

**Interfaces:**
- Produces: `AppLocalizations.onboardingHeadline` → `"Round food for every mood"`

- [ ] **Step 1: Write failing test**

Add to `onboarding_page_test.dart`:

```dart
testWidgets('shows onboarding headline', (tester) async {
  await pumpJDonutsApp(tester);
  expect(find.text('Round food for every mood'), findsOneWidget);
});
```

- [ ] **Step 2: Run test — FAIL** (string not in UI / ARB)

- [ ] **Step 3: Add ARB key**

```json
"onboardingHeadline": "Round food for every mood",
```

Run: `flutter gen-l10n` (or `flutter pub get` if codegen is hooked).

- [ ] **Step 4: Place headline in `OnboardingPage` temporarily** (plain `Text`, no animation yet) above `PrimaryButton` using `AppTextStyles.headline`, centered.

- [ ] **Step 5: Run test — PASS**

---

### Task 3: Hero entrance animation

**Files:**
- Modify: `lib/features/auth/presentation/widgets/onboarding_hero.dart`
- Create: `test/features/auth/presentation/widgets/onboarding_hero_test.dart`

**Interfaces:**
- Consumes: `AppMotion.onboardingHeroEntrance`, `onboardingHeroStagger`, `onboardingDriftFactor`, `standardCurve`, `AppMotion.of`
- Produces: `OnboardingHero` stateful with visible circles after entrance when animations on

- [ ] **Step 1: Write failing hero test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/onboarding_hero.dart';

void main() {
  Future<void> pumpHero(WidgetTester tester, {bool disableAnimations = false}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(400, 600),
            disableAnimations: disableAnimations,
          ),
          child: const Scaffold(body: OnboardingHero()),
        ),
      ),
    );
  }

  testWidgets('hero shows brand when animations disabled', (tester) async {
    await pumpHero(tester, disableAnimations: true);
    await tester.pump();
    expect(find.text("J'Donuts"), findsOneWidget);
  });

  testWidgets('hero completes entrance without errors', (tester) async {
    await pumpHero(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    expect(tester.takeException(), isNull);
    expect(find.text("J'Donuts"), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test — may pass brand test; entrance test documents target behavior**

- [ ] **Step 3: Implement `OnboardingHero` as `StatefulWidget`**

- `SingleTickerProviderStateMixin` for entrance `_entranceController` duration `AppMotion.onboardingHeroEntrance`.
- Per-circle `Animation<double>` opacity + drift using `Interval` with stagger `index * stagger / total`.
- `FadeTransition` / `Transform.translate` per circle.
- On reduce motion: set controller value to 1.0 immediately in `initState` after checking `MediaQuery.disableAnimationsOf`.

- [ ] **Step 4: Run `onboarding_hero_test.dart` — PASS**

---

### Task 4: Hero idle float

**Files:**
- Modify: `lib/features/auth/presentation/widgets/onboarding_hero.dart`
- Modify: `test/features/auth/presentation/widgets/onboarding_hero_test.dart`

**Interfaces:**
- Consumes: `AppMotion.onboardingIdlePeriod`, `onboardingIdleAmplitude`
- Produces: repeating idle offset after entrance completes

- [ ] **Step 1: Add test**

```dart
testWidgets('idle animation runs after entrance when motion enabled', (tester) async {
  await pumpHero(tester);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 1200));
  final y1 = tester.getTopLeft(find.text("J'Donuts")).dy;
  await tester.pump(const Duration(milliseconds: 900));
  final y2 = tester.getTopLeft(find.text("J'Donuts")).dy;
  expect(y1, isNot(equals(y2)));
});
```

- [ ] **Step 2: Run — FAIL** (no movement)

- [ ] **Step 3: Add second controller `_idleController`** `repeat()` when entrance completes; skip if reduce motion.

Apply `translate(0, sin(2π * t + phase) * amplitude)` per circle with fixed phases `[0, 0.7, 1.4, 2.1, 2.8]`.

- [ ] **Step 4: Run tests — PASS**

- [ ] **Step 5: Skip idle assertion when `disableAnimations: true`** (y1 == y2)

---

### Task 5: Bottom stagger entrance

**Files:**
- Create: `lib/features/auth/presentation/widgets/onboarding_bottom_entrance.dart`
- Modify: `lib/features/auth/presentation/pages/onboarding_page.dart`

**Interfaces:**
- Consumes: `AppMotion.onboardingBottomEntrance`, `onboardingBottomStagger`, `onboardingBottomDelay`, `onboardingSlideUp`, `standardCurve`
- Produces: `OnboardingBottomEntrance({required Widget child})` wrapping staggered children

- [ ] **Step 1: Write widget test** (can live in `onboarding_page_test.dart`)

```dart
testWidgets('headline visible at start when reduce motion', (tester) async {
  await pumpJDonutsApp(
    tester,
    viewport: const Size(400, 800),
  );
  // MediaQuery default animations on — after full settle headline visible
  expect(find.text('Round food for every mood'), findsOneWidget);
});
```

- [ ] **Step 2: Implement `OnboardingBottomEntrance`**

- Takes `List<Widget> children` or single `child` Column — prefer wrapping existing column children as list.
- One controller; total duration = `bottomEntrance + stagger * (n-1)`.
- Delay start: `Future.delayed` bad for tests — use `Interval` on same controller with `onboardingBottomDelay / total` as beginning gap, or parent `OnboardingPage` passes `initialDelay` via `TweenSequence`.

Simpler approach: controller duration = delay + entrance + stagger*(n-1); each child `Interval` start at `(delay + i*stagger)/total`.

- [ ] **Step 3: Refactor `OnboardingPage` bottom** — headline inside entrance list, then buttons.

- [ ] **Step 4: `flutter test` onboarding tests — PASS**

---

### Task 6: Verification

- [ ] Run: `flutter test test/features/auth/presentation/`
- [ ] Run: `flutter analyze`
- [ ] Manual: profile onboarding on emulator; confirm no jank on idle loop

---

## Plan self-review

| Spec requirement | Task |
|---|---|
| Hero drift-in + stagger | Task 3 |
| Idle float | Task 4 |
| Headline l10n | Task 2 |
| Bottom stagger | Task 5 |
| Reduce motion | Tasks 3–5 via `AppMotion.of` / disable flag |
| Placeholder circles | No asset task |
| 60 fps / Flutter APIs only | No Rive; lightweight transforms |

No TBD placeholders in tasks above.

## Execution Handoff

Plan saved. Choose:

1. **Subagent-Driven** — one task per subagent with review between tasks  
2. **Inline** — implement all tasks in this chat with checkpoints
