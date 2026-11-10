# j_donuts_app

Madivizion Flutter code test — J'Donuts customer app slice (Tasks 1–2 implemented; Task 3 Rewards placeholder).

## Versions

| Tool | Version |
|------|---------|
| Flutter | 3.44.8 (stable) |
| Dart | 3.12.2 |

## Run

```bash
flutter pub get
flutter run
flutter analyze
flutter test
flutter test integration_test/register_to_product_test.dart   # device/emulator; allow USB install
```

## State management

**Riverpod 3** — providers are the composition root (`core/di`, feature `presentation/providers`). No services constructed inside widgets. `AsyncValue` / sealed notifier states drive loading and error UI.

## Architecture (feature-first)

```
lib/
  core/          theme tokens, motion, router, connectivity, errors, shared widgets
  l10n/          gen-l10n ARB strings
  features/
    auth/        domain validators + AuthRepository; fake impl + secure session/registered phones
    catalog/     Drift DB, seed JSON, repository
    home/        Home shell, sections, offline banner
    product/     Product detail, quantity, MMK formatting
    rewards/     placeholder (Task 3)
```

Dependencies point inward: presentation → domain ← data.

## Navigation

`go_router` with session redirect (logged in → Home; logged out → Onboarding). Product deep link: `/product/:id`. Registration uses shared-axis transitions; Home uses `StatefulNavigationShell` for tabs.

## Offline strategy

- **Source of truth:** Drift (SQLite) seeded from `assets/seed/catalog_v1.json` on first open; idempotent re-sync on pull-to-refresh.
- **Images:** Bundled `assets/images/seed/*` plus optional `imageUrl` via `cached_network_image`.
- **Connectivity:** `connectivity_plus` plus HTTP reachability; offline banner on Home while offline.
- **Auth (fake):** Registered phone numbers persisted in secure storage; session phone in `flutter_secure_storage`.

## Animations (Madivizion §6)

| Area | Implementation |
|------|----------------|
| Onboarding | Hero image slide; bottom CTAs staggered; reduce motion short-circuits durations |
| Registration | Shared-axis / fade-through routes; progress ring tween; OTP shake |
| Buttons | `PrimaryButton` press scale + loading morph |
| Welcome | Staggered donut tiles; title/button fade-up |
| Home | Shimmer skeletons; staggered section entrance; banner auto-advance (4s); pull-to-refresh donut |
| Product | `OpenContainer` from tile; quantity `AnimatedSwitcher` |
| Bottom nav | Animated pill width/label for active tab |

Motion durations and curves live in `lib/core/constants/app_motion.dart`.

## Fake OTP

Use **`123456`** on the verify-number step. Three wrong attempts lock until Resend (5:00 countdown).

## Tests

- Unit: domain validators, auth repository, catalog seed, MMK formatter
- Widget: auth steps, home sections, product detail
- Integration: register → welcome → home → coconut product (`integration_test/register_to_product_test.dart`)

## Known gaps

- **Task 3 Rewards** — placeholder screen only (no ring, tiers, challenges).
- **Delivery artifacts** — APK / iOS simulator `.app` and screen recording not included in repo (build locally).
- **Burmese locale** — English ARB only (bonus locale not done).
- Per-section **independent** error streams not implemented; one sections provider failure marks all sections with retry.

## Device check

| Date | Device | Text scale 1.3 | Notes | Pass |
|------|--------|----------------|-------|------|
| _TBD_ | | 1.3 | Ring / toast / spinner | |

## Madivizion Task 1 notes

| Topic | Implementation |
|-------|----------------|
| Phone validation | Inline under field on blur / Done |
| Session | Secure storage; relaunch → Home; Settings → Log out |
| Social / legal | Coming soon toast |
| Registered users | Persisted E.164 set in secure storage |

## Time spent

_TBD — fill before submission._
