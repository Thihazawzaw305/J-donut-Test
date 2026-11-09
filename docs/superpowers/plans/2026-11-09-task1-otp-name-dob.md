# Task 1 (part 2) — OTP, Name, DOB Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans. Steps use checkbox (`- [ ]`) syntax.

**Goal:** OTP, name, and date-of-birth screens matching the J'Donuts screenshots, with real validation, fake 1s auth, and placeholder Welcome/Home exits.

**Architecture:** Extend `AuthRepository` + fake. Pure domain validators. Per-step Riverpod notifiers + shared `AuthDraft`. Reuse `AuthStepScaffold`. OTP auto-submits at 6 digits (no Continue). DOB ring becomes a check.

**Tech stack:** Flutter 3.44.8, Riverpod 3.5, go_router 18, gen-l10n, existing tokens.

**Spec:** `docs/superpowers/specs/2026-11-09-task1-otp-name-dob-design.md`

## Global Constraints

- Domain has no Flutter imports. Presentation maps failures to ARB.
- No hard-coded user-visible strings or colours in widgets (`AppColors`, `AppTextStyles`, `AppDimens`, `AppMotion`).
- OTP errors: shake + clear + message under boxes. Name/DOB: inline. Toast only for repo/submit failures.
- Fake OTP `123456`. Resend from `5:00` (`OtpPolicy.resendSeconds = 300`). Lock after 3 wrong until resend.
- OTP screenshot has **no Continue**; auto-submit when 6 digits filled. Double-tap/double-fill = one request.
- Age ≥ `AgePolicy.minAgeYears` (13). Last name optional.
- Back keeps draft. Register ring: step 2/3/4; login OTP hides ring.
- Files ~300 lines, functions ~20, pages < ~80. `flutter analyze` clean. Tests named by behaviour.
- Update `ControllableAuthRepository` whenever `AuthRepository` grows (stub unused methods).
- Never commit `Madivizion_Flutter_Code_Test.pdf` or design screenshots.

## Model routing (controller)

- Composer (`composer-2.5`): mechanical domain validators, mappers, ARB, dimen tokens.
- Grok (`cursor-grok-4.6-medium` if listed, else session default / `composer-2.5` fallback): OTP notifier+page, DOB picker, fake-repo attempt lock, widget tests with animation.

---

### Task 1: OTP / name / DOB domain types and validators

**Files:**
- Create: `lib/features/auth/domain/entities/otp_code.dart`, `person_name.dart`, `date_of_birth.dart`
- Create: `lib/features/auth/domain/policies/otp_policy.dart`, `age_policy.dart`
- Create: `lib/features/auth/domain/failures/otp_validation_failure.dart`, `name_validation_failure.dart`, `dob_validation_failure.dart`
- Create: `lib/features/auth/domain/validators/otp_validator.dart`, `name_validator.dart`, `dob_validator.dart`
- Test: `test/features/auth/domain/validators/otp_validator_test.dart`, `name_validator_test.dart`, `dob_validator_test.dart`

**Interfaces:**
- `class OtpCode { const OtpCode(this.digits); final String digits; }` length 6.
- `abstract final class OtpPolicy { static const codeLength = 6; static const maxAttempts = 3; static const resendSeconds = 300; static const correctCode = '123456'; }`
- `abstract final class AgePolicy { static const minAgeYears = 13; }`
- `enum OtpValidationFailure implements Failure { incomplete, nonDigit }`
- `Result<OtpCode, OtpValidationFailure> validateOtp(String raw)` — strip spaces; must be exactly 6 digits.
- `enum NameValidationFailure implements Failure { empty, tooLong, containsDigit, invalidCharacters }`
- `Result<String, NameValidationFailure> validateFirstName(String raw)` — trim; empty → empty; >50 → tooLong; any digit → containsDigit; not `^[\p{L} ]+$` unicode → invalidCharacters; else Ok(trimmed).
- `Result<String?, NameValidationFailure> validateLastName(String raw)` — trim empty → Ok(null); else same rules as first (no `empty`).
- `class DateOfBirth { year, month, day; DateTime toDate(); }`
- `enum DobValidationFailure implements Failure { incomplete, invalidDate, inFuture, tooYoung }`
- `Result<DateOfBirth, DobValidationFailure> validateDateOfBirth({int? year, int? month, int? day, required DateTime now})`

- [ ] **Step 1:** Write failing tests (one behaviour each): OTP incomplete (`12345`), non-digit, 6 digits Ok; first empty, 51 chars, digit, Myanmar letters Ok (`သီဟ`), last empty Ok(null); DOB 31 April invalidDate, 29 Feb 2024 Ok, 29 Feb 2025 invalid, tomorrow inFuture, age 12 tooYoung, age 13 Ok (birthday today).

- [ ] **Step 2:** `flutter test test/features/auth/domain/validators` — FAIL compile missing files.

- [ ] **Step 3:** Minimal implementations matching interfaces. Age: complete years from DOB to `now` date-only.

- [ ] **Step 4:** Tests pass.

- [ ] **Step 5:** Commit `feat(auth): add otp, name and date-of-birth validators`

---

### Task 2: Extend AuthRepository, fake, use cases

**Files:**
- Modify: `lib/features/auth/domain/repositories/auth_repository.dart`, `lib/features/auth/domain/failures/auth_failure.dart` (add `wrongOtp`, `otpLocked`)
- Modify: `lib/features/auth/data/repositories/fake_auth_repository.dart`
- Modify: `test/helpers/fake_repositories.dart` — implement new methods; `verifyCount`, `lastCode`; optional separate Completers or complete-next-call list.
- Create: `lib/features/auth/domain/usecases/verify_otp.dart`, `resend_otp.dart`, `save_profile_name.dart`, `complete_registration.dart`
- Test: `test/features/auth/data/repositories/fake_auth_repository_test.dart` (extend), `test/features/auth/domain/usecases/verify_otp_test.dart`

**Interfaces:**
```dart
Future<Result<void, AuthFailure>> verifyOtp(PhoneNumber phone, OtpCode code, {required AuthFlow flow});
Future<Result<void, AuthFailure>> resendOtp(PhoneNumber phone);
Future<Result<void, AuthFailure>> saveProfileName(PhoneNumber phone, {required String firstName, String? lastName});
Future<Result<void, AuthFailure>> completeRegistration(PhoneNumber phone, {required String firstName, String? lastName, required DateOfBirth dateOfBirth});
```

Fake: delay `latency`; login + unknown → `notRegistered`; code != `OtpPolicy.correctCode` increment attempts, if attempts >= 3 → `otpLocked` else `wrongOtp`; resend resets attempts; completeRegistration adds `phone.e164` to registered set.

ControllableAuthRepository: keep requestOtp as-is; new methods default `Ok(null)` immediately unless tests need a Completer for verifyOtp (`verifyCompleter`).

- [ ] Tests first (wrong, lock at 3, resend unlocks, 123456 Ok, completeRegistration then login Ok).
- [ ] Implement. Analyze clean.
- [ ] Commit `feat(auth): extend fake repository for otp and registration`

---

### Task 3: Draft + OTP notifier

**Files:**
- Modify: `auth_draft_notifier.dart` — add `otpInput`, `firstName`, `lastName`, `DateOfBirth? dateOfBirth` + updaters.
- Create: `otp_step_state.dart`, `otp_step_notifier.dart`; providers in `auth_providers.dart` (`verifyOtpProvider`, `resendOtpProvider`).
- Test: `test/features/auth/presentation/providers/otp_step_notifier_test.dart`

**OtpStepState:** `digits` (0–6), `locked`, `resendRemaining` int seconds (start 300, injectable ticker), `status` sealed idle/submitting/success/failure(AuthFailure), `shakeEpoch` int, `inlineMessage` from last wrong/locked.

**OtpStepNotifier(AuthFlow):**
- `build`: restore `otpInput` from draft; `resendRemaining = OtpPolicy.resendSeconds` (tests pass `ticker`? Keep simple: `resendRemaining` starts at 300; `tick()` decrements — UI uses Timer.periodic calling tick. Tests call `tick()` 300 times or set remaining via test-only... **Do not add test-only methods.** Inject `Duration Function() now` or start remaining at 300 and `onResendWindowElapsed` from tests by looping `tick()`. Add `void tick()` public — it's the clock callback, not a test-only API.
- `onChanged(String digits)` sanitize to digits max 6, save draft. If length==6 && !locked && !submitting → `submit()`.
- `submit`: verifyOtp with draft phone (parse via `validatePhone(draft.phoneInput)`). On wrongOtp: clear digits, ++shakeEpoch, set inline. On otpLocked: locked=true. On success: status success.
- `resend`: if remaining==0, call resendOtp, reset remaining 300, locked=false, clear inline.

Need phone on OTP page from draft. If empty, Back to phone.

- [ ] Tests: auto-submit at 6; second submit while in-flight ignored; 3 wrong → locked, submit ignored; tick to 0 then resend unlocks; restore digits from draft.
- [ ] Commit `feat(auth): add otp step notifier`

---

### Task 4: Name + DOB notifiers

**Files:** `name_step_state.dart`, `name_step_notifier.dart`, `dob_step_state.dart`, `dob_step_notifier.dart`; `saveProfileNameProvider`, `completeRegistrationProvider`.
- Tests: `name_step_notifier_test.dart`, `dob_step_notifier_test.dart`

Name: `canSubmit` = first Ok && last Ok; `submit` saveProfileName then success.

DOB: nullable y/m/d; `canSubmit` = validateDateOfBirth Ok (now: `DateTime.now()` in notifier, inject `DateTime Function() clock` on notifier constructor default `DateTime.now` — **family can't easily inject clock**. Use `Provider<DateTime Function()> clockProvider` default `DateTime.now` overridable in tests.

- [ ] Tests: invalid first blocks submit; last empty allowed; DOB 31 Apr cannot submit; valid DOB submit success; double submit one call.
- [ ] Commit `feat(auth): add name and date-of-birth notifiers`

---

### Task 5: Strings, tokens, ring check, mappers

**Files:**
- Modify `lib/l10n/app_en.arb` — keys: `otpSentTo` "We've sent 6 digit OTP to {e164}", `otpResendPrompt` "Didn't receive the code?", `otpResendIn` "resend in {mm} : {ss} min", `otpErrorWrong` "That code is incorrect.", `otpErrorLocked` "Too many tries. Resend a new code.", `firstNameHint`, `lastNameHint`, `nameTitle` "What's your name?", `firstNameError*`, `lastNameError*`, `dobTitle` "What's your date of birth?", `dayHint`, `monthHint`, `yearHint`, `selectBirthday`, `select`, `creating`, `dobError*`, `welcomeTitle` "Welcome", `homeTitle` "Home", month names if needed (`monthJanuary`… or format via `DateFormat` — **intl DateFormat.MMMM()** uses locale, no extra ARB for month names).
- `AppDimens.otpBoxSize = 48`, `otpBoxGap = 8`, `otpBoxRadius = 10`
- `failure_messages.dart` exhaustive switches for new failures (must compile).
- `StepProgressRing({bool showCheck = false})` — when `showCheck`, after tween ends (progress==1) paint filled `ringProgress` circle + white check path. Test: `currentStep: 4, totalSteps: 4, showCheck: true` painter or semantics.
- `flutter gen-l10n`. Commit generated l10n.

- [ ] Commit `feat(auth): add otp/name/dob strings, ring check and failure copy`

---

### Task 6: OTP page + widgets

**Files:** `otp_boxes.dart`, `otp_resend_row.dart`, `otp_page.dart`; wire router real `OtpPage` instead of placeholder.
- Tests: `otp_page_test.dart` via `pumpJDonutsApp` location `AppRoutes.registerOtp` with draft phone prefilled (`authDraftProvider` override or type on phone page first).

Behaviour tests:
- 6 boxes; typing 123456 with controllable repo in-flight shows (optional) blocking overlay or ignore extra keys; complete Ok → register name page / login home placeholder.
- Wrong 123457: boxes empty, inline `otpErrorWrong`, shakeEpoch used (find animation or just empty boxes + message).
- Login ring hidden; register ring shown.
- Resend text visible; after ticks not required in widget test if notifier tested.

Phone page already pushes otpRoute — keep.

`OtpPage` uses scaffold without `action` Continue — **AuthStepScaffold requires action**. Change scaffold: `Widget? action` nullable; if null, omit button but keep legal footer.

- [ ] Modify `AuthStepScaffold` `action` to `Widget? action` — if null skip. Update existing phone page (still passes action).
- [ ] OTP page < 80 lines.
- [ ] Commit `feat(auth): add verify-number screen`

---

### Task 7: Name page

**Files:** `name_fields.dart`, `name_page.dart`; routes `registerName = '/register/name'`.
- Tests: Continue disabled until first valid; inline on invalid first (digit); last empty OK; submit spinner then dob route; back keeps names.

Success navigation: `context.push(AppRoutes.registerDob)`.

- [ ] Commit `feat(auth): add name step`

---

### Task 8: DOB page + birthday sheet + creating overlay

**Files:** `dob_fields.dart`, `birthday_sheet.dart`, `creating_overlay.dart`, `dob_page.dart`; routes `registerDob`, `welcome`, `home`.
- Birthday sheet: `showModalBottomSheet` white, title `selectBirthday` pink, close, `CupertinoDatePicker` or 3 `ListWheel` — **CupertinoDatePicker mode date** is simpler and still a wheel. Max today, min today-120y. SELECT confirms.
- Fields read-only; tap opens sheet.
- Continue disabled until valid. Submit: Creating overlay + button loading; success → Welcome placeholder.
- Ring `currentStep: 4, showCheck: true`.
- Tests: continue disabled empty; select 30 May 2000 enables; submit → Welcome; overlay visible while in-flight.

- [ ] Commit `feat(auth): add date-of-birth step`

---

### Task 9: Navigation glue + login OTP → Home

- `AuthFlowRoutes.nameRoute` / `dobRoute` only register.
- OTP success: register → name; login → home.
- Name success → dob. Dob success → welcome.
- Phone page login unregistered still toast Register.
- After `completeRegistration`, fake has the number so later login works in-process (session persist still later).
- Widget test: register happy path Phone (optional skip) OTP 123456 → name → dob → welcome. Login: seed FakeAuthRepository registeredNumbers, OTP 123456 → home.

- [ ] `flutter analyze` + full `flutter test`.
- [ ] Commit `feat(auth): wire otp/name/dob routes and placeholders`

---

### Task 10: Fidelity pass

Compare screenshots: OTP title/subtitle, box size, resend copy, name field stack, DOB three fields + check ring, Creating pill. Fix tokens. No Cloudflare. `dart format`; analyze; tests.

- [ ] Commit `fix(auth): match otp/name/dob spacing to design`
