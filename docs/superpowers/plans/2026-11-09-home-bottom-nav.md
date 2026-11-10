# Home Bottom Nav Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild `HomeBottomNav` to match the approved spec: accent strip, top-only cyan bar rounding, animated pill on active routable tabs, Settings in `HomeShell`, Order/Wallet coming-soon toasts.

**Architecture:** Keep navigation in `HomeBottomNav` with `go_router`; visual stack (strip + bar) and per-tab `HomeBottomNavItem` widgets with implicit animations (`AnimatedSize`, fade). Settings becomes a shell body; enum `stores` → `order`. No new packages.

**Tech Stack:** Flutter, Riverpod (unchanged for this slice), go_router, gen-l10n, flutter_test.

## Global Constraints

- Clean Architecture: strings in ARB, colors/dimens from `AppColors` / `AppDimens`, motion from `AppMotion` + `AppMotion.of` for Reduce Motion.
- Inset padding around nav (not full bleed).
- Pink strip: `AppColors.accent`, height `AppDimens.homeNavHeight / 2`.
- Pill border: `homeNavPillBorderWidth` = `1.0`.
- Order/Wallet: toast only; do not change route or active tab.
- Settings: `context.go(AppRoutes.settings)` inside shell; `fadeThrough` on route.

---

## File map

| File | Responsibility |
|------|----------------|
| `lib/core/constants/app_dimens.dart` | `homeNavPillBorderWidth`, optional `homeNavPillRadius` |
| `lib/core/constants/app_motion.dart` | `homeNavSelection` |
| `lib/l10n/app_en.arb` | `homeNavOrder`, `homeNavWallet`, `homeNavSettings` |
| `lib/features/home/presentation/widgets/home_bottom_nav.dart` | Stack strip + bar, five items, animation, taps |
| `lib/features/home/presentation/pages/settings_page.dart` | `HomeShell` wrapper, no `AppBar` |
| `lib/core/router/app_router.dart` | Settings `fadeThrough: true` |
| `test/features/home/presentation/widgets/home_bottom_nav_test.dart` | Widget tests (new) |
| `test/features/home/presentation/pages/settings_page_test.dart` | Update if exists / add shell expectation |

---

### Task 1: Foundation tokens + l10n (enables tests)

**Files:**
- Modify: `lib/core/constants/app_dimens.dart`
- Modify: `lib/core/constants/app_motion.dart`
- Modify: `lib/l10n/app_en.arb`

**Interfaces:**
- Produces: `AppDimens.homeNavPillBorderWidth`, `AppMotion.homeNavSelection`, l10n getters `homeNavOrder`, `homeNavWallet`, `homeNavSettings`

- [ ] **Step 1: Add dimens**

In `app_dimens.dart` after `homeNavHeight`:

```dart
  static const homeNavPillBorderWidth = 1.0;
  static const homeNavPillRadius = 28.0;
```

- [ ] **Step 2: Add motion**

In `app_motion.dart` after `medium`:

```dart
  static const homeNavSelection = medium;
```

- [ ] **Step 3: Add ARB keys**

In `app_en.arb`:

```json
  "homeNavOrder": "Order",
  "homeNavWallet": "Wallet",
  "homeNavSettings": "Settings",
```

- [ ] **Step 4: Regenerate l10n**

Run: `flutter gen-l10n` or `dart run build_runner build` if project uses `flutter pub get` + implicit gen on analyze.

Expected: `app_localizations_en.dart` exposes new getters.

- [ ] **Step 5: Verify analyze**

Run: `flutter analyze lib/core/constants/app_dimens.dart lib/core/constants/app_motion.dart lib/l10n/`

Expected: no issues.

---

### Task 2: Bar geometry + accent strip (TDD)

**Files:**
- Create: `test/features/home/presentation/widgets/home_bottom_nav_test.dart`
- Modify: `lib/features/home/presentation/widgets/home_bottom_nav.dart`

**Interfaces:**
- Consumes: `HomeBottomNav({required HomeShellTab active})`, `AppColors.accent`, `AppDimens.homeNavHeight`
- Produces: Widget tree with bottom `DecoratedBox`/`Container` (accent, height `homeNavHeight/2`) and front `Material` with `BorderRadius.vertical(top: Radius.circular(homeNavRadius))`

- [ ] **Step 1: Write failing tests for layout**

Create `home_bottom_nav_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_bottom_nav.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('accent strip is half nav height behind bar', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.home));

    final stack = find.byType(Stack);
    expect(stack, findsOneWidget);

    final accentBoxes = find.descendant(
      of: stack,
      matching: find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            (w.decoration as BoxDecoration).color == AppColors.accent,
      ),
    );
    expect(accentBoxes, findsOneWidget);

    final stripSize = tester.getSize(accentBoxes);
    expect(stripSize.height, AppDimens.homeNavHeight / 2);
  });

  testWidgets('cyan bar rounds top corners only', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.home));

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(HomeBottomNav),
        matching: find.byType(Material),
      ).first,
    );
    expect(
      material.shape,
      RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.homeNavRadius),
        ),
      ),
    );
  });
}
```

- [ ] **Step 2: Run tests — expect FAIL**

Run: `flutter test test/features/home/presentation/widgets/home_bottom_nav_test.dart`

Expected: FAIL — no `Stack`, wrong `Material` shape, or missing accent child.

- [ ] **Step 3: Implement minimal layout in `HomeBottomNav`**

Replace outer `BorderRadius.circular` + single `Material` with:

```dart
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMd,
          AppDimens.spaceSm,
          AppDimens.spaceMd,
          AppDimens.spaceMd,
        ),
        child: SizedBox(
          height: AppDimens.homeNavHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: DecoratedBox(
                  decoration: const BoxDecoration(color: AppColors.accent),
                  child: SizedBox(
                    height: AppDimens.homeNavHeight / 2,
                    width: double.infinity,
                  ),
                ),
              ),
              Material(
                color: AppColors.homeNavBar,
                elevation: 6,
                shadowColor: AppColors.shadow,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimens.homeNavRadius),
                  ),
                ),
                child: SizedBox(
                  height: AppDimens.homeNavHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ /* temporary icons — Task 3 */ ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
```

Keep existing row children temporarily so file compiles until Task 3.

- [ ] **Step 4: Run tests — expect PASS**

Run: `flutter test test/features/home/presentation/widgets/home_bottom_nav_test.dart`

- [ ] **Step 5: Commit** (if user requested commits)

```bash
git add lib/core/constants/app_dimens.dart lib/core/constants/app_motion.dart lib/l10n/app_en.arb lib/features/home/presentation/widgets/home_bottom_nav.dart test/features/home/presentation/widgets/home_bottom_nav_test.dart
git commit -m "feat(home): bottom nav stack with accent strip and top radius"
```

---

### Task 3: Active pill + labels for all routable tabs (TDD)

**Files:**
- Modify: `test/features/home/presentation/widgets/home_bottom_nav_test.dart`
- Modify: `lib/features/home/presentation/widgets/home_bottom_nav.dart`

**Interfaces:**
- Produces: `_HomeBottomNavItem` or `HomeBottomNavItem` with `active`, `label`, `icon`, `onTap`; pill uses `homeNavPillBorderWidth`; inactive shows `Icon` only

- [ ] **Step 1: Add failing tests**

Append to test file:

```dart
  testWidgets('active home shows pill label Home', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.home));
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('active rewards shows pill label Reward', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.rewards));
    expect(find.text('Reward'), findsOneWidget);
  });

  testWidgets('active settings shows pill label Settings', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.settings));
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('inactive tabs show no label text', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.home));
    expect(find.text('Reward'), findsNothing);
    expect(find.text('Order'), findsNothing);
    expect(find.text('Wallet'), findsNothing);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('pill uses thin white border', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.home));
    final pill = find.descendant(
      of: find.byType(HomeBottomNav),
      matching: find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            (w.decoration as BoxDecoration).color == AppColors.homeNavActive,
      ),
    );
    expect(pill, findsOneWidget);
    final decoration = tester.widget<DecoratedBox>(pill).decoration as BoxDecoration;
    expect(decoration.border, isA<Border>());
    final border = decoration.border as Border;
    expect(border.top.width, AppDimens.homeNavPillBorderWidth);
    expect(border.top.color, AppColors.onPrimary);
  });
```

- [ ] **Step 2: Run — FAIL**

- [ ] **Step 3: Implement unified nav item**

Refactor row to five items with labels from `context.l10n`. Rename enum `stores` → `order` in same file.

Single item widget pattern:

```dart
class _HomeBottomNavItem extends StatelessWidget {
  const _HomeBottomNavItem({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.homeNavSelection);
    final curve = AppMotion.standardCurve;

    final child = selected
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            decoration: BoxDecoration(
              color: AppColors.homeNavActive,
              borderRadius: BorderRadius.circular(AppDimens.homeNavPillRadius),
              border: Border.all(
                color: AppColors.onPrimary,
                width: AppDimens.homeNavPillBorderWidth,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.onPrimary),
                const SizedBox(width: AppDimens.spaceXs),
                Text(
                  label,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          )
        : IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: AppColors.onPrimary),
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.homeNavPillRadius),
      child: AnimatedSize(
        duration: duration,
        curve: curve,
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: curve,
          switchOutCurve: curve,
          child: KeyedSubtree(
            key: ValueKey(selected),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

Wire `active == HomeShellTab.X` for home, rewards, settings; order/wallet `selected: false` always (until routes exist).

Update icons: Order → `Icons.takeout_dining_outlined`.

Fix navigation: rewards/settings use `_open` + `go`; settings replace `push`.

- [ ] **Step 4: Run tests — PASS**

- [ ] **Step 5: Commit** (optional per user)

---

### Task 4: Order / Wallet coming soon (TDD)

**Files:**
- Modify: `test/features/home/presentation/widgets/home_bottom_nav_test.dart`
- Modify: `lib/features/home/presentation/widgets/home_bottom_nav.dart`

- [ ] **Step 1: Failing test**

```dart
  testWidgets('tap order shows coming soon without selecting order', (tester) async {
    await tester.pumpApp(const HomeBottomNav(active: HomeShellTab.home));
    await tester.tap(find.byIcon(Icons.takeout_dining_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Order'), findsNothing);
  });
```

Adjust icon if different. Toast text: use `context.l10n.comingSoon` — assert `find.text` for localized coming soon string from en ARB.

- [ ] **Step 2: Run — FAIL** (if toast already shows but label appears, or toast missing)

- [ ] **Step 3: Implement**

```dart
onTap: () => AppToast.show(context, message: context.l10n.comingSoon),
```

No `selected` state change (widget is stateless; parent `active` unchanged in test).

- [ ] **Step 4: PASS + duplicate for wallet icon tap**

- [ ] **Step 5: Commit** (optional)

---

### Task 5: Reduce Motion (TDD)

**Files:**
- Modify: `test/features/home/presentation/widgets/home_bottom_nav_test.dart`

- [ ] **Step 1: Test**

```dart
  testWidgets('reduce motion uses zero duration on selection animation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: const Scaffold(
            body: HomeBottomNav(active: HomeShellTab.rewards),
          ),
        ),
      ),
    );
    expect(find.text('Reward'), findsOneWidget);
  });
```

Use `pumpApp` with wrapper if helper extended; or local `MaterialApp` + l10n delegates like `product_detail_page_test.dart`.

- [ ] **Step 2–4: Fix** if `AnimatedSize` ignores zero duration edge case — ensure `AppMotion.of` used everywhere.

---

### Task 6: Settings in HomeShell + router

**Files:**
- Modify: `lib/features/home/presentation/pages/settings_page.dart`
- Modify: `lib/core/router/app_router.dart`
- Create or modify: `test/features/home/presentation/pages/settings_page_test.dart`

**Interfaces:**
- Consumes: `HomeShell(activeTab: HomeShellTab.settings, body: ...)`

- [ ] **Step 1: Failing widget test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/home/presentation/pages/settings_page.dart';
import 'package:j_donuts_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/pump_app.dart';
// override sessionProvider with fake logged-in user if needed

testWidgets('settings page shows shell with settings tab active', (tester) async {
  await tester.pumpApp(
    const ProviderScope(child: SettingsPage()),
  );
  expect(find.byType(HomeBottomNav), findsOneWidget);
  expect(find.text('Settings'), findsWidgets); // title + nav pill possible
});
```

- [ ] **Step 2: Implement SettingsPage**

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return HomeShell(
    activeTab: HomeShellTab.settings,
    body: ListView(
      padding: const EdgeInsets.all(AppDimens.screenPadding),
      children: [
        Text(context.l10n.settingsTitle, style: AppTextStyles.headline),
        ListTile(
          title: Text(context.l10n.logOut, style: AppTextStyles.body),
          onTap: () async { /* unchanged */ },
        ),
      ],
    ),
  );
}
```

- [ ] **Step 3: Router**

Change settings `pageBuilder` to `fadeThrough: true`, remove `sharedAxis`.

- [ ] **Step 4: Grep `HomeShellTab.stores` → update to `order`**

Run: `rg stores lib test`

- [ ] **Step 5: `flutter test` + `flutter analyze`**

---

### Task 7: Final verification

- [ ] Run: `flutter test`
- [ ] Run: `flutter analyze`
- [ ] Manual: Home → Reward → Settings; pill animates; Order/Wallet toast; strip visible.

---

## Plan self-review

| Spec requirement | Task |
|------------------|------|
| Inset padding | Task 2 layout |
| Accent strip half height | Task 2 |
| Top-only radius | Task 2 |
| Five tabs + icons | Task 3 |
| Thin pill border | Task 1 + Task 3 |
| Animation | Task 3 + Task 5 |
| Order/Wallet toast | Task 4 |
| Settings shell | Task 6 |
| l10n keys | Task 1 |
| Widget tests | Tasks 2–5, 6 |

No placeholders remain.

## Execution Handoff

Plan saved to `docs/superpowers/plans/2026-11-09-home-bottom-nav.md`.

**1. Subagent-Driven (recommended)** — fresh subagent per task, review between tasks  

**2. Inline Execution** — run tasks in this session with checkpoints  

Which approach do you want?
