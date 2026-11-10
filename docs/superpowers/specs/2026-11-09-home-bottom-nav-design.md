# Home bottom navigation — pill tabs, pink strip, animation

Date: 2026-11-09  
Scope: `HomeBottomNav`, `HomeShell` integration, Settings as shell tab, l10n, motion tokens, widget tests.  
Reference: user mock — cyan bar (top corners only), accent strip behind lower half, selected pill with thin white stroke.

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Outer layout | **B** — keep inset padding around bar (`AppDimens.spaceMd` sides/bottom inside `SafeArea`) |
| Order tab | **A** — `AppToast` coming soon; no route; tab does not become active |
| Wallet tab | **A** — same as Order |
| Settings | **B** — `HomeShell` tab with `go(settings)`; pill + label when on `/settings` |
| Pink strip color | **A** — `AppColors.accent` (`#F2559A`), same family as active pill |
| Tab animation | **Approach 1** — per-item `AnimatedSize` + label fade; `AppMotion.homeNavSelection` |

## Goals

- Five tabs: **Home, Reward, Order, Wallet, Settings**.
- **Unselected:** white outlined icon only.
- **Selected:** pink pill (`homeNavActive`), icon + localized label, **thin white border** (1.0 logical px).
- **Animated** expand/collapse when switching between routable tabs (Home / Reward / Settings).
- Bar: **top-left and top-right rounded only**; bottom corners square.
- **Accent strip** behind bar: full width of padded nav container, height **half of** `homeNavHeight`, aligned to bottom of stack (visible under lower half of cyan bar).
- Every routable shell screen shows correct **active pill** (fix: only Home had pill today).
- Respect **Reduce Motion** via `AppMotion.of`.

## Non-goals

- Order / Wallet routes or screens.
- Full-bleed edge-to-edge nav (user chose inset).
- New pub dependencies.
- Bottom nav on product detail or auth flows.

## Visual structure

```
SafeArea (top: false)
  Padding (LTRB: spaceMd, spaceSm, spaceMd, spaceMd)
    Stack (clipBehavior: clip.none or similar)
      [back] Container — accent, width: max, height: homeNavHeight/2, bottom-aligned
      [front] Material — homeNavBar, BorderRadius.vertical(top: homeNavRadius)
        SizedBox(height: homeNavHeight)
          Row(spaceEvenly) → five HomeBottomNavItem widgets
```

**Pill (selected routable tab only)**

- Padding: horizontal `spaceMd`, vertical `spaceSm` (match current).
- `BorderRadius.circular(28)` (or `homeNavPillRadius` constant).
- Border: `AppColors.onPrimary`, width `homeNavPillBorderWidth` (1.0).
- Label: `AppTextStyles.bodyBold`, `onPrimary`.

**Icons (Material outlined, onPrimary)**

| Tab | Icon |
|-----|------|
| Home | `Icons.home_outlined` |
| Reward | `Icons.emoji_events_outlined` |
| Order | `Icons.takeout_dining_outlined` |
| Wallet | `Icons.account_balance_wallet_outlined` |
| Settings | `Icons.settings_outlined` |

## Navigation and behavior

| Tab | `onTap` | Updates `HomeShellTab` / route? |
|-----|---------|-------------------------------|
| Home | `context.go(AppRoutes.home)` | Yes |
| Reward | `context.go(AppRoutes.rewards)` if not already there | Yes |
| Settings | `context.go(AppRoutes.settings)` | Yes |
| Order | `AppToast.show(comingSoon)` | **No** — stay on current route and active tab |
| Wallet | `AppToast.show(comingSoon)` | **No** |

Rename enum value: `HomeShellTab.stores` → `HomeShellTab.order` (no route for order).

**Settings page**

- Wrap body in `HomeShell(activeTab: HomeShellTab.settings, body: ...)`.
- Remove standalone `Scaffold` + `AppBar` pattern; use in-body title (`settingsTitle`) and existing logout `ListTile`.
- Router: settings route uses `fadeThrough: true` like home/rewards (drop vertical `sharedAxis`).

**Rewards page**

- Already uses `HomeShell`; ensure `activeTab: HomeShellTab.rewards` shows Reward pill after nav refactor.

## Motion

Add to `AppMotion`:

| Token | Value | Use |
|-------|-------|-----|
| `homeNavSelection` | `medium` (300ms) | Pill width + label fade |

Curve: `standardCurve` (`easeOutCubic`).  
Reduce Motion: `AppMotion.of(context, homeNavSelection)` → zero duration; instant layout.

Implementation sketch per item:

- `AnimatedSize` (or `AnimatedContainer` with width from intrinsic child) for pill vs icon-only.
- `FadeTransition` / `AnimatedOpacity` for label when `active`.
- Inactive items: no pill decoration, `IconButton` or `InkWell` with min 48dp touch target.

## Localization

Add ARB keys:

- `homeNavOrder` → "Order"
- `homeNavWallet` → "Wallet"
- `homeNavSettings` → "Settings"

Existing: `homeNavHome`, `homeNavReward`.

## Tokens (`AppDimens`)

- `homeNavPillBorderWidth` = `1.0`
- Optional: `homeNavPillRadius` = `28.0` (if extracted from magic number)

Strip height: `homeNavHeight / 2` (document in widget; no separate const unless clarity needs it).

## Testing (TDD)

File: `test/features/home/presentation/widgets/home_bottom_nav_test.dart`

1. Active Home — finds pill label `homeNavHome`.
2. Active Reward — label `homeNavReward` when `active: HomeShellTab.rewards`.
3. Inactive slot — no `Text` for that tab's label (icon-present only).
4. Tap Order — `comingSoon` toast (or mock toast); `active` unchanged in parent test harness.
5. Pink strip present — `accent` colored box with height half of nav (layout predicate).
6. Bar shape — `Material` / container with `BorderRadius.vertical(top: ...)` only (widget property or golden optional).
7. Reduce Motion — `MediaQuery(disableAnimations: true)`; pump selection change; no exception, final state correct.

Mirror `lib/` path under `test/`. Use `ProviderScope` / `MaterialApp` + l10n test wrapper consistent with existing widget tests.

## Files touched (expected)

- `lib/features/home/presentation/widgets/home_bottom_nav.dart`
- `lib/features/home/presentation/pages/settings_page.dart`
- `lib/core/router/app_router.dart`
- `lib/core/constants/app_dimens.dart`
- `lib/core/constants/app_motion.dart`
- `lib/l10n/app_en.arb` (+ generated l10n)
- `test/features/home/presentation/widgets/home_bottom_nav_test.dart`
- Any references to `HomeShellTab.stores` → `order`

## Success criteria

- Visual match to mock: cyan top-rounded bar, accent half-height strip, thin-bordered pill on active routable tab.
- Tab switch Home ↔ Reward ↔ Settings animates pill unless Reduce Motion.
- Order / Wallet show coming soon without changing selection.
- `flutter analyze` clean; new widget tests pass.
