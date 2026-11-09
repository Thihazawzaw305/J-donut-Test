# Task 1 (part 2) — OTP, Name, Date of Birth

Date: 2026-11-09
Scope: Registration steps 2–4 and login OTP, pixel-matched to the provided screenshots. Welcome and Home stay placeholders. Session persistence is out of scope.

## Goals

- OTP verify screen with 6 boxes, 5:00 resend, shake + under-box error, lock after 3 wrong codes.
- Name screen with first (required) and last (optional) fields and inline errors.
- Date of birth screen with day/month/year, birthday wheel sheet, ring morphs to check, Creating overlay on submit.
- UI matches screenshots (spacing, type, colours, progress ring). No Cloudflare.
- Same foundation: Riverpod, `AuthRepository` fake (~1s), pure domain validators + unit tests, ARB strings, `AppColors` / `AppMotion`, `AuthStepScaffold`.
- Back keeps entered OTP/name/DOB via `AuthDraft`.

## Non-goals

- Welcome / Home real screens (placeholder titles only).
- `flutter_secure_storage` session, Settings logout, Drift.
- Real SMS, social login, Apple button (screenshot has Google + Facebook only).
- Onboarding donut photos (still placeholders).

## Error policy (user decision)

| Surface | Validation fail | Repo / submit fail |
|---|---|---|
| OTP | Boxes shake + clear; message **under** the boxes | Toast |
| Name | Inline under the field | Toast |
| DOB | Inline; Continue stays disabled | Toast |

## Tokens (existing)

Reuse `AppColors`, `AppDimens`, `AppTextStyles`, `AppMotion`. Add only:

- `AppDimens.otpBoxSize` (48), `otpBoxGap` (8), `otpBoxRadius` (10)
- `AppColors.otpCursor` = `accent`
- `minAgeYears = 13` in domain (`AgePolicy.minAgeYears`)
- `OtpPolicy.codeLength = 6`, `maxAttempts = 3`, `resendSeconds = 300`, `correctCode = '123456'`

## Architecture

Same layers as part 1. Per-step notifiers + shared `AuthDraft` (approach A).

```
lib/features/auth/
  domain/
    entities/otp_code.dart, person_name.dart, date_of_birth.dart
    failures/otp_failure.dart, name_validation_failure.dart, dob_validation_failure.dart
    validators/otp_validator.dart, name_validator.dart, dob_validator.dart
    repositories/auth_repository.dart          (extend)
    usecases/verify_otp.dart, resend_otp.dart, save_profile_name.dart, complete_registration.dart
  data/repositories/fake_auth_repository.dart  (extend)
  presentation/
    pages/otp_page.dart, name_page.dart, dob_page.dart
    widgets/otp_boxes.dart, otp_resend_row.dart, name_fields.dart,
            dob_fields.dart, birthday_sheet.dart, creating_overlay.dart
            step_progress_ring.dart            (add completed/check)
    providers/otp_step_notifier.dart, name_step_notifier.dart, dob_step_notifier.dart
    mappers/failure_messages.dart              (extend)
```

Placeholder pages: `AppRoutes.welcome = '/welcome'`, `home = '/home'`.

## Domain

### OTP

`OtpCode` holds 6 digit string. `validateOtpDigits(String)` → `Result<OtpCode, OtpValidationFailure>` (`incomplete`, `nonDigit`). Repository checks the fake code.

`AuthFailure` add: `wrongOtp`, `otpLocked`.

`verifyOtp(phone, code, {flow})`:
- login unknown number → `notRegistered`
- wrong code → `wrongOtp` (fake counts attempts per phone)
- 3 wrong → `otpLocked` until `resendOtp`
- `123456` → `Ok`

`resendOtp(phone)`: 1s delay, reset attempt count, Ok.

### Name

`validateFirstName` / `validateLastName`: trim; first empty → `empty`; last empty → Ok(null); length 1–50; `RegExp` letters + spaces including Myanmar (`\p{L}` plus space) — Dart: allow Unicode letters via `!contains(RegExp(r'\d'))` AND `every char is letter or space` using `RegExp(r'^[\p{L} ]+$', unicode: true)`. Digits → `containsDigit`. Other symbols → `invalidCharacters`.

### DOB

`DateOfBirth(year, month, day)`. `validateDateOfBirth({year, month, day}, {required DateTime now})`:
- missing field → `incomplete`
- not a real calendar date → `invalidDate`
- date after today (date-only, local) → `inFuture`
- age < 13 on `now` → `tooYoung`
- else Ok

Age: years = now.year - y; if (now.month, now.day) before (month, day) then years - 1.

## Data

`FakeAuthRepository` keeps:
- registered E.164 set (still empty until completeRegistration)
- attempts map E.164 → int
- `latency` injectable

`completeRegistration(phone, first, last, dob)`: 1s, add E.164 to registered set, Ok. `saveProfileName` 1s Ok (stores in memory map for later session; this round only delay).

## Presentation

`AuthDraft` fields: `phoneInput`, `otpInput`, `firstName`, `lastName`, `dob` (`DateOfBirth?`).

`OtpStepNotifier` (family `AuthFlow`): digits string (0–6), `attemptsUsed`, `locked`, `resendRemaining` (ticker), `status` idle/submitting/success/failure, `shakeToken` int increment on wrong. `onDigitAt(index)`, `onBackspace`, `onPaste`, `submit` when length==6 auto-submit (also Continue if we keep a hidden submit — **no Continue on OTP screenshot**; verify auto-submits at 6 digits). Resend disabled while remaining > 0.

OTP screenshot has **no Continue button**. Auto-submit when 6 digits filled. Keyboard numeric.

`NameStepNotifier`: first/last, validation results, submit.

`DobStepNotifier`: day/month/year ints nullable, picker selection, submit with Creating overlay (`isSubmitting`).

`StepProgressRing`: if `currentStep == totalSteps` after animation completes, paint filled pink circle + white check (screenshot). `completed: true` when DOB screen.

## UI fidelity

- Same `AuthStepScaffold` (back, ring, title, body, legal). OTP: no bottom Continue; legal still at bottom.
- OTP boxes: white, rounded 10, cursor cyan/pink accent in first empty.
- Resend: “Didn’t receive the code? resend in M : SS min” — countdown pink on time.
- Name/DOB fields: white 68-tall, 10 radius, placeholders Day/Month/Year/First Name/Last Name.
- Birthday sheet: white, title pink “Select your Birthday”, close X, 3-column wheel, cyan SELECT.
- Creating: small white pill overlay “Creating...” centered.

## Tests (TDD)

- otp/name/dob validators: one test per rule (including Myanmar letter, leap 29 Feb, 31 April, age 12 vs 13).
- fake repo: wrong, lock at 3, resend unlocks, 123456 ok, completeRegistration registers number.
- notifiers: auto-submit at 6, double fill one request, lock, resend.
- widgets: OTP shake path, name inline, DOB continue disabled, ring check on step 4.

## Motion

OTP shake `AppMotion.medium`. Ring 50% → 75% → 100% then check. Reduce Motion: skip shake / snap ring. `AppMotion` constants only.
