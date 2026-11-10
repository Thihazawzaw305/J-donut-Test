# Home shop list — horizontal inset, inset image card

Date: 2026-11-10  
Scope: `HomeShopsSection` horizontal list padding, `HomeShopCard` inset image layout, `AppDimens` tokens, widget tests.  
Reference: user choice **A** — framed photo inside white card; list inset while scrolling; row height from layout tokens (not arbitrary viewport).

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Card image | **A** — inset on all sides inside white shell; image has its own radius on all four corners |
| Horizontal list | `ListView` padding `EdgeInsets.symmetric(horizontal: spaceMd)` — match `HomeProductSection` |
| Row height | Recompute `homeShopListHeight` from card layout constants after inset refactor (replace stale `336` if mismatched) |
| Image radius token | `homeShopCardImageRadius` = `12` (aligned with popular product cards) |
| Card outer radius | Unchanged `homeShopCardRadius` (`20`) |
| Text | Existing styles, max lines, ellipsis unchanged |

## Goals

- First and last shop cards keep **16 logical px** inset from screen edge **while scrolling** (start and end).
- Shop card reads as **padded white panel** with **rounded image** inside, not full-bleed hero image.
- List viewport height tracks **designed card height**, not a magic number that clips or leaves dead air.
- Widget tests lock list padding and inset image structure (TDD before production changes).

## Non-goals

- Tap navigation to shop detail or order flow.
- Changing shop data, background asset, or section title / Explore button layout.
- Variable per-card heights in the horizontal row (text still ellipsizes; one row height for all items).

## Card structure

```
Align(topCenter)
  SizedBox(width: homeShopCardWidth)
    Material(surface, elevation 3, borderRadius: homeShopCardRadius)
      Padding(all: spaceMd)
        Column(stretch, min)
          ClipRRect(radius: homeShopCardImageRadius)
            SizedBox(height: homeShopCardImageHeight)
              CatalogImage(cover)
          SizedBox(height: spaceMd)
          Text title (homeShopCardTitle, max 2 lines)
          SizedBox(height: spaceXs)
          Text address (caption, max 3 lines)
          SizedBox(height: spaceMd)
          Text link (homeOrderOnline)
```

- Remove top-level `clipBehavior: Clip.antiAlias` on `Material` if it only served full-bleed image; clipping is on the image `ClipRRect` only.
- Do **not** nest a second horizontal `spaceMd` on the text block (outer `Padding` owns insets).

## List structure

In `HomeShopsSection`, horizontal `ListView.separated`:

- `padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd)`
- `separatorBuilder`: `SizedBox(width: spaceMd)` (unchanged)
- Wrapper `SizedBox(height: AppDimens.homeShopListHeight)` unchanged pattern; **update constant** after card layout:

```
homeShopListHeight =
  spaceMd           // card top inset
  + homeShopCardImageHeight
  + spaceMd         // gap image → title
  + _shopTextBlockHeight  // see below
  + spaceMd;        // card bottom inset
```

`_shopTextBlockHeight` is a **layout budget** for title (2 lines at `homeShopCardTitle` line height), `spaceXs`, address (3 lines at caption), `spaceMd`, and one link line — implemented as a single derived constant or documented numeric in `AppDimens` so tests and list height stay in sync. Prefer one named constant `homeShopCardTextBlockHeight` if the arithmetic is noisy.

## Files

| File | Change |
|------|--------|
| `lib/core/constants/app_dimens.dart` | Add `homeShopCardImageRadius`; adjust `homeShopListHeight` (+ optional `homeShopCardTextBlockHeight`) |
| `lib/features/home/presentation/widgets/home_shop_card.dart` | Inset layout per structure above |
| `lib/features/home/presentation/widgets/home_shops_section.dart` | List horizontal padding |
| `test/.../home_shop_card_test.dart` | Assert `ClipRRect`, inset `Padding`, image not flush to `Material` top |
| `test/.../home_shops_section_test.dart` | Assert `ListView` padding horizontal `spaceMd` |

## Testing (TDD order)

1. Extend `home_shops_section_test` — expect horizontal padding on scroll view (RED).
2. Extend `home_shop_card_test` — inset image with `ClipRRect` and `homeShopCardImageRadius` (RED).
3. Implement card + section (GREEN).
4. Run existing home widget tests; `flutter analyze` clean.

## Error / edge cases

- Empty `shops`: section still `SizedBox.shrink()`; no test change required.
- Long localized strings: ellipsis unchanged; no scroll inside card.
- Reduce motion: N/A (no new animation).
