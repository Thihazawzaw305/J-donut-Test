# Task 2 — Home, Product Detail, Offline Catalog

## Scope

Madivizion Task 2: bundled JSON → Drift (SQLite), Home (screen 8), Product detail (screen 9), offline banner, image assets + cache hooks, single seeded member record shared with future Rewards.

Out of scope here: Rewards motion (Task 3), persistent cart, mock HTTP server.

## Data

- `assets/seed/catalog_v1.json`: member, banners, products, sections (ordered, each with `cardStyle`: `largeRect` | `mediumRect` | `square`), shops.
- On first DB open: idempotent seed if `products` empty.
- `CatalogRepository`: watch sections with products, watch member, watch shops, get product by id, `refreshFromSeed()` for pull-to-refresh (re-read JSON).
- Connectivity: `connectivity_plus` + optional reachability; `offlineBannerVisible` provider for Home.
- Images: primary `imageAsset` in seed (bundled); optional `imageUrl` for future sync via `cached_network_image`.

## Home layout (UI fidelity)

Vertical `CustomScrollView` (no outer spinner; skeletons while loading):

1. **Header shell** — `AppColors.homeHeader` fill, radius only bottom-left/right (~28). Profile row (avatar, name, subtitle), orange notification pill, white tier progress capsule. Banner `PageView` (viewportFraction ~0.88, auto-advance optional later) overlapping header bottom.
2. **Sections** — For each seeded section: title row (localized title + chevron FAB) + horizontal list. `largeRect` / `mediumRect` = white rounded cards, image on top, name below; `square` = ~1:1 rounded cards (Donuts, Bread, Cookies, Cake).
3. **Nearby shops** — Sky gradient block, localized count line, CTA pill (no-op), horizontal shop cards (image, name, address, “Order online” link style).
4. **Bottom nav** — Cyan rounded bar; Home active pink pill (icon + label); Crown / donut / wallet / settings → placeholder snackbar or existing settings route for gear.

## Product detail

Route `/product/:id`. Load product from DB. Layout per screenshot: back + favorite, white rounded card (name, price MMK formatted, image), quantity stepper (min 1), “What’s this?” + description, bottom cyan split bar ADD TO CART | total. `OpenContainer` from home product tiles when opened from Home.

## Architecture

```
catalog/  domain entities + CatalogRepository interface + seed parse use case
          data Drift DAOs, mappers, repository impl, JSON DTOs
home/     presentation providers + page/widgets (thin page)
product/  presentation detail page + quantity notifier
core/di/  databaseProvider, catalogProviders, connectivityProviders
```

## States

Each home section: loading skeleton, data, error with retry, empty. Home page: top-level error only if member/sections fail entirely.

## Testing (TDD)

- Unit: seed JSON → domain entities; MMK price formatter; product lookup.
- Drift: in-memory DB seed idempotent.
- Widget: home header tier text; product tile navigates to detail; quantity stepper updates total.
- Update integration: Register → Home → tap product tile → coconut detail title.

## Motion (minimal Task 2)

Skeleton shimmer placeholder; defer staggered section entrance to Task 3 unless cheap. Respect `MediaQuery.disableAnimations`.
