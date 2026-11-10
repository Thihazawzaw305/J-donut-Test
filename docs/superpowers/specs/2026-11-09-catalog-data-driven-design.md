# Catalog data-driven presentation (Madivizion Task 2 compliance)

Date: 2026-11-09  
Authority: Madivizion Flutter code test Task 2 (bundled catalog), aligned with `docs/superpowers/specs/2026-11-09-task2-home-product-design.md` and project clean-architecture rules (gen-l10n, Drift as SSOT).

## Goal

Ensure every **catalog-visible** value on Home and Product detail—lists, nesting, images, prices, member fields, shop count—comes from **seed JSON → Drift → entities → providers**, not fixed strings or mock lists in widgets. Translatable catalog copy uses **keys stored in data** resolved through **ARB** (`catalogString` / parameterized helpers). UI chrome (nav, CTAs, errors) stays l10n-only and is out of scope.

## Non-goals

- Moving product/shop names into JSON as literal strings (conflicts with gen-l10n and Task 2 “localized title”).
- Auth onboarding copy, Rewards placeholder, bottom-nav “coming soon”.
- New network API or cart persistence.
- Showing price on home product tiles (Task 2 screenshot: price on detail only).

## Data boundary

| Source | Fields |
|--------|--------|
| `assets/seed/catalog_v1.json` | Member, banners, products, sections (`productIds`, `cardStyle`), shops; `*Key` fields for localized strings; prices, assets, flags |
| Drift | Same columns after idempotent seed |
| Entities | `CatalogMember`, `CatalogProduct`, `CatalogSection`, `CatalogShop`, `CatalogBanner` |
| ARB | Strings for each `*Key` in seed; templates with placeholders (`memberTierProgressSilver`, `homeShopsNearby`, `discountBadge`) |

Presentation rules:

- **Lists and nesting:** Built only from repository streams / section entities—no parallel hardcoded product IDs in widgets.
- **Images:** `CatalogImage` with `imageAsset` / optional `imageUrl` from entity.
- **Prices:** `product.priceMmk` + `formatMmkPrice`; line total = price × quantity on detail.
- **Member display name:** `member.displayName` from data (not l10n).
- **Member subtitle:** `catalogString(l10n, member.subtitleKey)`.
- **Section / product / shop text:** `catalogString(l10n, *Key)` only—never paste ARB English strings in widgets.
- **Shop count line:** `context.l10n.homeShopsNearby(shops.length)`—count from data, sentence from l10n.

## Known gap (fix required)

`HomeHeaderPanel` ignores `member.tierProgressKey` and always calls `context.l10n.memberTierProgressSilver(kyats)`. Seed and Drift already store `tierProgressKey`; UI must respect it.

## Tier progress resolver

Add `catalogMemberTierProgress(AppLocalizations l10n, CatalogMember member)` in `lib/features/catalog/presentation/catalog_strings.dart` (or adjacent catalog presentation helper):

- Format `member.tierProgressKyats` with existing `NumberFormat('#,###')` pattern (same as header today).
- `switch (member.tierProgressKey)`:
  - `'memberTierProgressSilver'` → `l10n.memberTierProgressSilver(kyats)`.
  - Unknown key → empty string in release builds; in debug, assert or log once (no raw key shown to users).

`HomeHeaderPanel` uses this helper instead of direct l10n call.

Future tier keys: add ARB entry + seed value + switch arm (same pattern as `catalogString`).

## `catalogString` contract

Keep existing key → l10n mapping for all seed keys in `catalog_v1.json`. Do not remove the switch; it is the intentional bridge between data keys and localization.

Optional hardening (implementation plan may include): debug-only assert when `catalogString` hits `_ => key` for keys that look like catalog keys (`product*`, `shop*`, `homeSection*`).

## Widget audit checklist (must pass)

| Widget / page | Data used |
|---------------|-----------|
| `HomePage` | Providers → sections, member, shops, banners |
| `HomeHeaderPanel` | `displayName`, `subtitleKey`, `tierProgressKey` + `tierProgressKyats`, avatar, banners |
| `HomeProductSection` | `section.titleKey`, products from section entity |
| `HomeProductTile` | `nameKey`, images, badges from product flags |
| `HomeShopsSection` | `shops.length`, per-shop keys + `imageAsset` |
| `HomeBannerCarousel` | banner `imageAsset` list |
| `ProductDetailPage` | Load by id; `nameKey`, `descriptionKey`, `priceMmk`, image |

No inline catalog product names, shop names, or section titles in `lib/features/{home,product,catalog}/presentation/` except inside `catalog_strings.dart` mapping to l10n.

## Architecture

No domain-layer changes required unless tests expose a mapper bug. Changes confined to:

- `catalog/presentation/catalog_strings.dart` (tier helper)
- `home/presentation/widgets/home_header_panel.dart` (wire tier helper)
- `test/...` (TDD additions)

## Error handling

Unchanged: home/product already use `AsyncValue` / provider errors. Empty shop list → `SizedBox.shrink`. Missing product on detail → existing error UI.

## Testing (TDD — red before production fix)

1. **`home_header_panel_test`**
   - Pump with `CatalogMember` where `tierProgressKyats: 999` (and `tierProgressKey: 'memberTierProgressSilver'`).
   - Expect tier pill text contains `999` (formatted with grouping as locale allows).
   - Proves pill text derives from entity, not a constant.

2. **`product_detail_page_test`**
   - Extend or add case: in-memory DB / override with product `priceMmk: 9999` (or quantity stepper case asserting total reflects **entity** price).
   - Expect `9,999 Ks` (or equivalent formatted) on screen after quantity change.
   - Proves price path is data-driven.

3. **Regression**
   - `flutter test` full suite; integration `register_to_product_test` still finds `Coconut Donut` and `3,200 Ks` from seed → l10n.

4. **Optional guard test**
   - Lightweight test that reads known ARB product titles and fails if they appear as string literals in presentation `.dart` files (exclude `catalog_strings.dart` and `test/`).

## Verification before merge

```bash
flutter analyze
flutter test
```

## Relation to Task 2 parent spec

This doc narrows Task 2 “Testing” with explicit data-binding cases for tier and price. It does not change layout, motion, or seed schema.
