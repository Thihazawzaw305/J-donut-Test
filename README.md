# j_donuts_app

Madivizion Flutter code test — J'Donuts customer app slice (Tasks 1–3).

Repo: https://github.com/Thihazawzaw305/J-donut-Test

## Versions

| Tool | Version |
|------|---------|
| Flutter | 3.44.8 (stable) |
| Dart | 3.12.2 |

CI pins the same Flutter version in `.github/workflows/ci.yml`.

## Run

```bash
flutter pub get
flutter run
flutter analyze
flutter test
flutter test integration_test/register_to_product_test.dart   # device/emulator; allow USB install
```

### Release APK

```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

Release builds need `INTERNET` in the main `AndroidManifest` for connectivity reachability and remote images.

### iOS Simulator `.app` (zip)

Requires macOS + Xcode locally, or the GitHub Actions workflow (no local Mac needed):

1. Push this repo to GitHub.
2. Open **Actions** → **ios-simulator-app** → **Run workflow**.
3. When the run finishes, download the **Runner.app.zip** artifact.
4. Submit that zip (unzipped contents are the Simulator `.app`).

Local Mac equivalent:

```bash
flutter build ios --simulator --debug --no-codesign
# then zip build/ios/iphonesimulator/Runner.app → Runner.app.zip
# (--release is not supported for simulators)
```

Workflow: `.github/workflows/ios-simulator-app.yml` (manual `workflow_dispatch` only — saves macOS CI minutes).

## State management

**Riverpod 3** — providers are the composition root (`core/di`, feature `presentation/providers`). No services constructed inside widgets. `AsyncValue` / sealed notifier states drive loading and error UI.

## Architecture (feature-first)

```
lib/
  core/          theme tokens, motion, router, connectivity, errors, shared widgets
  l10n/          gen-l10n ARB strings (en + my)
  features/
    auth/        domain validators + AuthRepository; fake impl + secure session/registered phones
    catalog/     Drift DB, seed JSON, repository
    home/        Home shell, sections, offline banner, pull-to-refresh
    product/     Product detail, quantity, MMK formatting
    rewards/     Tier ladder, points ring, challenges, tab motion (Task 3)
```

Dependencies point inward: presentation → domain ← data.

## Navigation

`go_router` with session redirect (logged in → Home; logged out → Onboarding). Product deep link: `/product/:id`. Registration uses shared-axis transitions; Home uses `StatefulNavigationShell` for tabs (Home, Rewards, Settings).

## Offline strategy

- **Source of truth:** Drift (SQLite) seeded from `assets/seed/catalog_v1.json` on first open; idempotent re-sync on pull-to-refresh.
- **Images:** Bundled `assets/images/seed/*` plus optional `imageUrl` via `cached_network_image`.
- **Connectivity:** `connectivity_plus` plus HTTP reachability; offline banner on Home while offline.
- **Offline banner:** Fixed above the scroll view (not a sliver) so overscroll still arms pull-to-refresh.
- **Auth (fake):** Registered phone numbers persisted in secure storage; session phone in `flutter_secure_storage`.

## Animations (Madivizion §6)

| Area | Implementation |
|------|----------------|
| Onboarding | Solid surface; bottom CTAs staggered; reduce motion short-circuits durations |
| Registration | Shared-axis / fade-through routes; progress ring tween; OTP shake |
| Buttons | `PrimaryButton` press scale + loading morph |
| Welcome | Staggered donut tiles; title/button fade-up |
| Home | Shimmer skeletons; staggered section entrance; banner auto-advance (4s); pull-to-refresh donut |
| Product | `OpenContainer` from tile; quantity `AnimatedSwitcher` |
| Rewards | Ring sweep + points count-up; tier stagger; tab thumb slide; challenge stagger; donut quarter clip; coffee arc |
| Bottom nav | Animated pill width/label for active tab |

Motion durations and curves live in `lib/core/constants/app_motion.dart`.

## Fake OTP

Use **`123456`** on the verify-number step. Three wrong attempts lock until Resend (5:00 countdown).

## Tests

- Unit: domain validators, auth repository, catalog seed, MMK formatter, rewards progress helpers
- Widget: auth steps, home sections (incl. section error panel + offline pull-refresh), product detail, rewards motion widgets
- Integration: register → welcome → home → coconut product (`integration_test/register_to_product_test.dart`)

## Known gaps

- **Delivery artifacts** — APK build locally; iOS Simulator `.app` via Actions workflow or a Mac; screen recording not in repo.
- **Burmese locale** — `lib/l10n/app_my.arb` covers UI copy; product names and descriptions, shop names and addresses, and tier titles fall back to English.
- Product sections load from one Drift stream; if it fails, Home still renders header, banners and shops, with one `HomeSectionStatePanel` retry in place of the product sections (no per-section streams, no hardcoded fallback catalog).
- Integration tests find widgets by English text, so run them on a device set to English.

CI (`.github/workflows/ci.yml`) runs `flutter analyze` and `flutter test`. Manual workflow `ios-simulator-app` builds and uploads `Runner.app.zip`.

## Madivizion Task 1 notes

| Topic | Implementation |
|-------|----------------|
| Phone validation | Inline under field on blur / Done |
| Session | Secure storage; relaunch → Home; Settings → Log out |
| Social / legal | Coming soon toast |
| Registered users | Persisted E.164 set in secure storage |

## Rewards seed (Task 3)

Member row in `catalog_v1.json`: `pointsBalance` 680000, `tierCode` silver, `rewardsPillCount` 3, `tierLadderFillBp` 8500. Ring arc uses `rewardsDonutRingTarget(member)` (tier fill × display sweep cap).

## Time spent

_TBD — fill before submission._
