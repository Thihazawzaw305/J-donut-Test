# Task 1 (part 1) — Onboarding + Phone Number Screen

Date: 2026-11-09
Scope: Onboarding screen, Phone number screen, and the foundation the remaining
Task 1 steps (OTP, Name, Date of birth) plug into.

## Goals

- Onboarding screen with layout matching design; donut/logo images are placeholders (real assets added later).
- Phone number screen (step 1 of 4) with real validation, animated progress ring, loading Continue button.
- All errors shown as **toasts** (user decision; overrides spec's inline messages).
- No Cloudflare widget.
- Foundation: theme tokens, motion constants, `Result`/`Failure`, gen-l10n, `go_router`, Riverpod DI, `AuthRepository` + fake impl.

## Non-goals (this round)

- OTP, Name, DOB, Welcome screens (routes exist as placeholders).
- Session persistence (`flutter_secure_storage`), Drift, auth redirect guard.
- Real social login.

## Design tokens (sampled from screenshots)

| Token | Hex | Use |
|---|---|---|
| `primary` | `#32C4E9` | Primary buttons |
| `accent` | `#F2559A` | Links (Log In, Terms, Privacy) |
| `ringProgress` | `#FF4C9E` | Progress ring fill, check |
| `ringTrack` | `#61D3F8` | Progress ring track |
| `backgroundTop` | `#FFD6E6` | Gradient top |
| `backgroundMiddle` | `#FFECF2` | Gradient middle |
| `backgroundBottom` | `#FFF7FA` | Gradient bottom |
| `textPrimary` | `#1E1E22` | Titles, input text |
| `textHint` | `#999999` | `+95` prefix, placeholders |
| `textMuted` | `#787677` | Legal footer |
| `surface` | `#FFFFFF` | Inputs, back button, toast |
| `disabled` | `#32C4E9` @ 50% | Disabled primary button |
| `error` | `#E5484D` | Toast error icon |

Font: Urbanist (bundled TTF, offline-safe). Replaceable later.

## Architecture

State: Riverpod 3 (manual providers, no codegen). Sealed classes for state/failures.

```
lib/
  app.dart                          MaterialApp.router, theme, l10n
  main.dart                         ProviderScope
  core/
    constants/ app_colors.dart, app_motion.dart, app_dimens.dart
    theme/     app_theme.dart, app_text_styles.dart
    errors/    result.dart, failure.dart
    router/    app_router.dart, app_routes.dart
    widgets/   app_toast.dart, primary_button.dart, gradient_background.dart
    l10n/      l10n_extension.dart
  l10n/        app_en.arb
  features/auth/
    domain/
      entities/phone_number.dart
      failures/auth_failure.dart, phone_validation_failure.dart
      repositories/auth_repository.dart
      usecases/request_otp.dart
      validators/phone_validator.dart
    data/
      repositories/fake_auth_repository.dart
    presentation/
      pages/onboarding_page.dart, phone_page.dart, placeholder_page.dart
      widgets/step_progress_ring.dart, phone_input_field.dart, legal_footer.dart,
              social_login_row.dart, onboarding_hero.dart, auth_back_button.dart
      providers/auth_providers.dart, registration_draft_notifier.dart,
                phone_step_notifier.dart, phone_step_state.dart
      mappers/failure_messages.dart   failure -> localized string
```

## Domain

`validatePhone(String raw) -> Result<PhoneNumber, PhoneValidationFailure>`
1. Remove spaces and dashes.
2. Empty -> `PhoneValidationFailure.empty`.
3. Strip one leading `0`.
4. Must match `^9\d{7,9}$` else `PhoneValidationFailure.invalidFormat`.
5. Success -> `PhoneNumber(nationalNumber)`, `e164 = +95<national>`.

`AuthRepository`
- `Future<Result<void, AuthFailure>> requestOtp(PhoneNumber phone, {required AuthFlow flow})`
- `AuthFlow { register, login }`
- `AuthFailure` sealed: `notRegistered`, `alreadyRegistered`, `unknown`.

`RequestOtp` use case: delegates to repository.

## Data

`FakeAuthRepository`: in-memory `Set<String>` of registered E.164 numbers, `Duration` delay (default 1s, injectable, zero in tests).
- login + unknown number -> `notRegistered`.
- register + known number -> `alreadyRegistered`.
- else success.

## Presentation

`RegistrationDraftNotifier` (Notifier, kept alive): holds raw phone text so Back keeps input.

`PhoneStepNotifier` (Notifier, family by `AuthFlow`), state `PhoneStepState`:
- `rawInput`, `validation` (`Result`), `status` sealed: `PhoneIdle`, `PhoneSubmitting`, `PhoneSubmitSuccess(PhoneNumber)`, `PhoneSubmitFailure(AuthFailure)`.
- `onChanged(String)`: revalidate.
- `submit()`: ignored when invalid or already submitting (double-tap guard); calls use case.

`PhonePage`:
- Back button, progress ring (register flow only, 25%), title, `+95` field, Continue, legal footer.
- Continue disabled while invalid; shows spinner while submitting.
- Field blur / keyboard done with invalid non-empty input -> toast with localized message.
- Success -> push OTP placeholder route. Failure -> toast; `notRegistered` toast offers "Register" action that switches to register flow.

`OnboardingPage`: hero placeholder (circles), logo placeholder, Let's get started -> `/register/phone`, Log in -> `/login/phone`, Google + Facebook buttons and Terms/Privacy -> "coming soon" toast.

`AppToast`: overlay entry, slides/fades in from bottom, auto-dismiss (duration in `AppMotion`), optional action, error/info variants, respects Reduce Motion.

`StepProgressRing`: `CustomPainter` arcs, animates from previous to current fraction via `TweenAnimationBuilder`; at 100% shows check (later steps).

## Routes

`/` onboarding, `/register/phone`, `/login/phone`, `/register/otp`, `/login/otp` (placeholders).

## Testing (TDD)

- `phone_validator_test`: empty, spaces/dashes stripped, leading 0 stripped once, must start with 9, 7–9 digits after 9 (boundary 6/7/9/10), non-digits rejected, E.164 output.
- `fake_auth_repository_test`: register new ok, register existing fails, login unknown fails, login known ok.
- `request_otp_test`: delegates and returns repository result.
- `phone_step_notifier_test`: invalid blocks submit; double submit calls repo once; success/failure status.
- Widget: `phone_page_test` — Continue disabled when invalid, enabled when valid, toast on blur with invalid input, spinner while submitting, navigates on success, toast on `notRegistered`.
- Widget: `step_progress_ring_test` — paints given fraction.
- Widget: `onboarding_page_test` — buttons route correctly; social buttons show toast.
