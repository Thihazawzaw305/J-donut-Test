# Home header + banner carousel (mock fidelity)

Date: 2026-11-09  
Scope: `HomeHeaderPanel`, `HomeNotificationButton`, `HomeBannerCarousel`, related tokens/skeleton only.  
Reference: user home mock (profile row, tier pill, promo carousel).

## Goals

- Peach header background aligned with mock (not cyan).
- Smaller display name; subtitle unchanged hierarchy.
- Notification pill: shorter, wider, thick white stroke, flush to physical right edge.
- Tier progress pill: much smaller type/padding, left-aligned with avatar column, width hugs text.
- No vertical gap between tier pill and banner carousel inside header shell.
- Banner carousel: **manual swipe only** (no auto-advance); **infinite** loop via modulo indexing.
- TDD: widget tests written first for the behaviors above.

## Non-goals

- Orange crescent avatar ring (not in approved slice).
- Changing tier copy / points vs kyats strings in l10n.
- New pub dependencies.
- Shops nav, product sections, or catalog data changes.

## Visual tokens

### Colors

- `AppColors.homeHeader` → peach cream. Use existing `AppColors.heroPeach` (`0xFFFCE3D6`) unless golden-test contrast fails; then add `homeHeaderPeach` alias pointing at sampled mock value.
- Notification: fill `notificationOrange`; border `onPrimary` (white), width from dimen below.

### Typography

- Add `AppTextStyles.homeMemberName`: Urbanist, **18**, w800, `textPrimary`, height ~1.25.
- Tier pill text: `AppTextStyles.body` at **13** or dedicated `homeTierPill` (13, w700) — prefer single new style if body at 15 reads too large in tests.

### Dimens (add to `AppDimens`)

| Token | Value | Use |
|---|---|---|
| `homeNotificationHeight` | 36 | Fixed notification pill height |
| `homeNotificationMinWidth` | 72 | Wider pill silhouette |
| `homeNotificationBorderWidth` | 3 | White stroke |
| `homeNotificationRadius` | 18 | Half of height |
| `homeTierPillRadius` | 20 | Smaller chip |
| `homeTierPillPaddingH` | 12 | Horizontal inner padding |
| `homeTierPillPaddingV` | 6 | Vertical inner padding |
| `homeHeaderGapProfileToPill` | 8 | Replaces generic `spaceMd` between row and pill |
| `homeHeaderPaddingBottom` | 16 | Bottom of header (was `spaceLg`); 0 gap pill→carousel |

## Layout — `HomeHeaderPanel`

### Padding structure

- Container padding: `fromLTRB(spaceMd, spaceMd, 0, homeHeaderPaddingBottom)` so trailing edge is open for notification bleed.
- Profile block (avatar + name column) keeps `spaceMd` left inset.

### Profile row

- Avatar: 52×52 oval (unchanged).
- Name: `homeMemberName`; subtitle: `body` + `textMuted`.
- `HomeNotificationButton` in row, aligned vertically center; **no trailing padding** on header for this row.

### Notification placement

- Pill trailing edge coincides with screen right (SafeArea respected top; horizontal SafeArea: allow bleed into trailing inset only for notification).
- Implementation: `Align(alignment: Alignment.centerRight)` or `Row` with `Spacer` + button extending with `margin: EdgeInsets.only(right: 0)` and optional negative offset equal to removed parent padding — prefer structural `padding.right = 0` on panel over magic negative margin.

### Tier pill

- `Align(alignment: Alignment.centerLeft)` or column `crossAxisAlignment: start`.
- Left edge aligns with avatar left (same `spaceMd` inset), not under name text only.
- `Container` with `mainAxisSize: min` child semantics via intrinsic width: wrap in `Row(mainAxisSize: min)` or pill without `stretch` parent.
- `textAlign: TextAlign.start`.
- Spacing to carousel: **0** — remove `SizedBox` between pill and `HomeBannerCarousel`.

### Banner within header

- Carousel remains last child of peach `Column`; header bottom radius unchanged (`homeHeaderRadius`).

## Carousel — `HomeBannerCarousel`

### Remove autoplay

- Delete `Timer`, `_scheduleAutoPlay`, `didChangeDependencies` autoplay hook, and `dart:async` import if unused.

### Infinite manual scroll

- Approach: keep `PageView.builder` + `PageController(viewportFraction: homeBannerViewportFraction)`.
- `itemCount`: large fixed value (e.g. `10000`) or `null` if SDK allows; builder uses `banner = banners[index % banners.length]`.
- `initState`: if `banners.length > 1`, `initialPage = kMiddle * banners.length` where `kMiddle = itemCount ~/ 2` rounded to multiple of length so user can swipe both directions immediately.
- Single banner: `itemCount: 1`, no infinite logic.
- Empty list: `SizedBox.shrink()` (unchanged).

### Accessibility / motion

- No programmatic page changes after mount (manual only).
- If later adding snap helpers, still gate on `MediaQuery.disableAnimationsOf`.

## Skeleton — `HomeLoadingSkeleton`

- Header block color matches peach `homeHeader`.
- Spacing mirrors tightened header (no large gap before banner placeholder).

## Architecture

No new domain/data work. Presentation-only changes:

```
core/constants/app_colors.dart
core/constants/app_dimens.dart
core/theme/app_text_styles.dart
features/home/presentation/widgets/
  home_header_panel.dart
  home_notification_button.dart
  home_banner_carousel.dart
  home_loading_skeleton.dart
test/features/home/presentation/widgets/
  home_notification_button_test.dart   (new)
  home_header_panel_test.dart          (new)
  home_banner_carousel_test.dart       (new)
```

Extract `HomeTierProgressPill` only if `home_header_panel.dart` exceeds ~80 lines after edit.

## Testing (TDD order)

1. **`home_notification_button_test`**
   - Finds `BoxDecoration` border side width ≥ `homeNotificationBorderWidth`, color white/onPrimary.
   - Constrained height ≈ `homeNotificationHeight`.

2. **`home_header_panel_test`**
   - Pump with fake `CatalogMember` + banners.
   - Display name `Text` uses `homeMemberName` (not `headline`).
   - Tier pill: one `Text` with start align; ancestor `Align` or column start; pill not full viewport width (width < screen − padding fudge).

3. **`home_banner_carousel_test`**
   - With 2+ banners: `pump` + `pump(Duration(seconds: 5))` with no drag → expect page index unchanged (no autoplay).
   - `drag` horizontal → expect displayed banner index changes per modulo (compare asset keys or semantics).

Use existing catalog test fixtures / provider overrides mirroring other widget tests in repo.

## Verification

- `flutter test` on new widget tests green after implementation.
- `flutter analyze` clean.
- Manual: Home screen matches mock spacing, peach header, infinite swipe.

## Decisions log

| Topic | Decision |
|---|---|
| Header color | Peach (`heroPeach`) |
| Notification edge | Flush right via zero trailing header padding |
| Tier pill width | Hug text, left under avatar |
| Carousel infinite | PageView modulo (option A) |
| Autoplay | Removed |
