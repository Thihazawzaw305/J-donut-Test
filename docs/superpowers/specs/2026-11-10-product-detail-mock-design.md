# Product detail — mock fidelity (screen 9)

Date: 2026-11-10  
Scope: Visual/layout polish of `ProductDetailPage` to match item-details mock. Presentation layer only.  
Builds on: `2026-11-09-task2-home-product-design.md` (route, data, footer, stepper).

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Header | Back + favorite (favorite → `comingSoon` toast) |
| Price format | `formatMmkPrice` → `X,XXX Ks` (card + footer) |
| Card badges | `product.code` top-left (caption/muted); orange **New** top-right when `isNew`; **no** discount badge on detail |
| Layout approach | Thin page + `ProductDetailHeroCard` + `ProductDetailDescriptionPanel` (approach 1) |
| Help icon | Decorative only (no tap) |
| Add to cart | Toast only (unchanged) |

## Goals

- White hero card matches mock: SKU row, title, unit price, centered product image.
- Quantity stepper **overlaps** bottom edge of hero card (pill sits half on card, half below).
- “What’s this?” block: green icon + title column, vertical divider, description on the right.
- Keep existing async load, not-found, error, min quantity 1, line total in footer.
- TDD: widget tests for new widgets + extend page tests before layout implementation.

## Non-goals

- Persistent cart, favorite backend, MMK suffix, discount on detail screen.
- Shared `ProductPromoBadge` in `core/widgets` (home `_Badge` stays local).
- Domain/data/schema changes.

## Layout

### Scaffold

- Background: `AppColors.homeScreenBackground`.
- Column: top app bar row → `Expanded` scroll body → `ProductDetailFooter` (unchanged split button).

### App bar

- Leading: back → `context.pop()`.
- Trailing: favorite (`productFavorite` tooltip) → `AppToast` `comingSoon`.

### Hero card (`ProductDetailHeroCard`)

```
Stack (clipBehavior: none)
  Material(white, radius: homeCardRadius)
    Padding(bottom: extra for stepper overlap)
      Column(crossAxis: stretch)
        Row: Text(code, caption/muted) | Spacer | [New pill if isNew]
        Text(name, headline)
        Text(unitPrice, bodyBold)
        SizedBox(height: productDetailImageHeight)
          Center → CatalogImage(contain)
  Positioned(bottom: -overlap) / Align
    Center → ProductQuantityStepper
```

- **New pill:** same visual as home `_Badge` — `AppColors.notificationOrange`, radius 12, `productNewBadge` from l10n, `AppTextStyles.caption` on primary.
- **Stepper:** reuse `ProductQuantityStepper`; overlap distance = `AppDimens.productDetailStepperOverlap`.

### Description (`ProductDetailDescriptionPanel`)

```
Row(crossAxis: start)
  SizedBox(width: productDetailHelpColumnWidth)
    Column: CircleAvatar(productHelpGreen, help icon) → Text(productWhatsThis, bodyBold)
  VerticalDivider or Container(width: 1)
  Expanded → Text(description, body)
```

- Scroll padding below hero accounts for stepper overlap (`spaceLg` + overlap).

### Footer

- Unchanged: `ProductDetailFooter` with `addToCart` + formatted line total (`priceMmk * quantity`).

## Architecture

| Action | Path |
|--------|------|
| Modify | `lib/features/product/presentation/pages/product_detail_page.dart` |
| Add | `lib/features/product/presentation/widgets/product_detail_hero_card.dart` |
| Add | `lib/features/product/presentation/widgets/product_detail_description_panel.dart` |
| Modify | `lib/core/constants/app_dimens.dart` |
| Modify | `test/features/product/presentation/product_detail_page_test.dart` |
| Add | `test/features/product/presentation/widgets/product_detail_hero_card_test.dart` |
| Add | `test/features/product/presentation/widgets/product_detail_description_panel_test.dart` |

**Data flow:** `productId` → `productByIdProvider` → `AsyncValue<CatalogProduct?>` → widgets receive resolved strings + image fields + quantity callbacks from page state.

**States:** loading spinner, provider error text, `productNotFound`, data layout as above.

## Testing (TDD)

Order: red → green per file.

1. **`product_detail_hero_card_test.dart`**
   - Renders `product.code`.
   - Shows `productNewBadge` when `isNew: true`.
   - Does not show `productNewBadge` when `isNew: false`.
   - Does not show discount badge text when `discountPercent` set.

2. **`product_detail_description_panel_test.dart`**
   - Finds `productWhatsThis` and description in one `Row` (e.g. ancestor `Row` or both visible).

3. **`product_detail_page_test.dart`**
   - Keep: quantity min 1, line total updates, unit price from entity.
   - Add: favorite control present (tooltip `productFavorite`).

4. **Regression:** `integration_test/register_to_product_test.dart` — coconut detail + `3,200 Ks` still passes.

Inject product fields via constructor on new widgets; page tests use `productByIdProvider` override pattern already in repo.

## Tokens (`AppDimens`)

| Constant | Purpose | Initial value |
|----------|---------|----------------|
| `productDetailImageHeight` | Hero image area | `220` |
| `productDetailStepperOverlap` | Stepper overlap below card | `24` |
| `productDetailHelpColumnWidth` | Left column in description row | `88` |
| `productDetailHelpDividerWidth` | Vertical rule | `1` |

No new colors. SKU line uses `AppTextStyles.caption` (`AppColors.textMuted`).

## Motion

- No new transitions on detail.
- `OpenContainer` from `HomeProductTile` unchanged.
- Respect `MediaQuery.disableAnimations` for any future motion (none in this change).

## Verification checklist

- [ ] `flutter test test/features/product/`
- [ ] `flutter test integration_test/register_to_product_test.dart` (or full integration if CI runs it)
- [ ] `flutter analyze` clean
