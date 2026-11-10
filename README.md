# j_donuts_app

Madivizion Flutter code test — J'Donuts (Clean Architecture, Riverpod, go_router).

## Branch scope

`feat/task1-onboarding-phone` includes **Madivizion Task 1** auth: onboarding through Welcome/Home, session persistence, OTP/Name/DOB, plus Task 2 placeholders (Home shell, product detail stub). Onboarding **hero motion** may land in a separate commit (`docs/superpowers/plans/2026-11-09-onboarding-hero-motion.md`).

## Madivizion Task 1 notes for graders

| Topic | Implementation |
|-------|----------------|
| Phone validation errors | **Inline** under the field on blur / keyboard Done (Madivizion §3). Auth/API failures still use themed toasts with actions where needed. |
| Session | `flutter_secure_storage` via `SessionRepository`; relaunch with session → **Home**, cleared → **Onboarding**. |
| Welcome | Real `WelcomePage` with “Let's explore” → Home. |
| Log out | **Settings** (gear on Home) → Log out. |
| Draft notifier naming | Code uses `auth_draft_notifier` / `AuthDraft` (plan name); design spec diagram may say `registration_draft`. |

## Device check (Task 10)

Record manual QA here when you run on a device/emulator:

| Date | Device | Text scale 1.3 | Ring / toast / spinner | Pass |
|------|--------|----------------|------------------------|------|
| _TBD_ | _e.g. Pixel emulator_ | | | |

```bash
flutter run
flutter analyze
flutter test
```

## Tests

- Unit/widget: `flutter test`
- Integration (device/emulator): `flutter test integration_test/register_to_product_test.dart`
