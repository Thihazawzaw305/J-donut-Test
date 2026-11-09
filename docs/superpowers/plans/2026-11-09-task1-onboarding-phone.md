# Task 1 (part 1) — Onboarding + Phone Screen Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Onboarding screen + phone number step (1 of 4) with real validation, animated progress ring, loading Continue, toast errors, plus the foundation the next auth steps plug into.

**Architecture:** Feature-first Clean Architecture. Pure-Dart domain (validator, `AuthRepository`, `RequestOtp`), fake data impl, Riverpod 3 notifiers with sealed state in presentation, `go_router` for navigation. Toasts are floating `SnackBar`s styled via theme so they are framework-managed and widget-testable.

**Tech Stack:** Flutter 3.44.8 / Dart 3.12.2, `flutter_riverpod ^3.5.0`, `go_router ^18.1.3`, `intl ^0.20.2`, `flutter_localizations`, gen-l10n, Urbanist font (bundled).

**Spec:** `docs/superpowers/specs/2026-11-09-task1-onboarding-phone-design.md`

## Global Constraints

- Domain has no Flutter imports. Presentation maps failures to localized text.
- No hard-coded user-visible strings (ARB via gen-l10n) or colors (`AppColors`) in widgets.
- Durations/curves only from `AppMotion`; respect `MediaQuery.disableAnimationsOf`.
- Files ~300 lines max, functions ~20 lines max, pages < 80 lines; named constants.
- Every error shown as a toast (`AppToast.show`). No Cloudflare widget.
- Phone rule: strip spaces, dashes, one leading `0`; result must be `9` + 7–9 digits; E.164 = `+95` + national.
- Continue disabled while invalid; one request on double tap; spinner while fake call runs.
- Fake auth latency 1 second (`FakeAuthRepository.defaultLatency`).
- `flutter analyze` clean; tests named by behaviour.
- Never commit `Madivizion_Flutter_Code_Test.pdf` or design screenshots.

## File Map

```
pubspec.yaml                     MODIFY  fonts, generate: true (deps already added)
l10n.yaml                        CREATE  gen-l10n config
analysis_options.yaml            MODIFY  extra lints
assets/fonts/Urbanist-*.ttf      EXISTS  (downloaded)
lib/main.dart                    REPLACE ProviderScope + JDonutsApp
lib/app.dart                     CREATE  MaterialApp.router
lib/l10n/app_en.arb              CREATE  strings
lib/core/errors/failure.dart     CREATE
lib/core/errors/result.dart      CREATE
lib/core/constants/app_colors.dart   CREATE
lib/core/constants/app_dimens.dart   CREATE
lib/core/constants/app_motion.dart   CREATE
lib/core/theme/app_text_styles.dart  CREATE
lib/core/theme/app_theme.dart        CREATE
lib/core/l10n/l10n_extension.dart    CREATE
lib/core/widgets/gradient_background.dart CREATE
lib/core/widgets/app_toast.dart      CREATE
lib/core/widgets/primary_button.dart CREATE
lib/core/widgets/placeholder_page.dart CREATE
lib/core/router/app_routes.dart      CREATE
lib/core/router/app_router.dart      CREATE
lib/features/auth/domain/entities/phone_number.dart
lib/features/auth/domain/entities/auth_flow.dart
lib/features/auth/domain/failures/phone_validation_failure.dart
lib/features/auth/domain/failures/auth_failure.dart
lib/features/auth/domain/validators/phone_validator.dart
lib/features/auth/domain/repositories/auth_repository.dart
lib/features/auth/domain/usecases/request_otp.dart
lib/features/auth/data/repositories/fake_auth_repository.dart
lib/features/auth/presentation/providers/auth_providers.dart
lib/features/auth/presentation/providers/auth_draft_notifier.dart
lib/features/auth/presentation/providers/phone_step_state.dart
lib/features/auth/presentation/providers/phone_step_notifier.dart
lib/features/auth/presentation/mappers/failure_messages.dart
lib/features/auth/presentation/auth_routes.dart
lib/features/auth/presentation/widgets/step_progress_ring.dart
lib/features/auth/presentation/widgets/auth_back_button.dart
lib/features/auth/presentation/widgets/legal_footer.dart
lib/features/auth/presentation/widgets/phone_input_field.dart
lib/features/auth/presentation/widgets/auth_step_scaffold.dart
lib/features/auth/presentation/widgets/onboarding_hero.dart
lib/features/auth/presentation/widgets/login_prompt.dart
lib/features/auth/presentation/widgets/social_login_row.dart
lib/features/auth/presentation/pages/onboarding_page.dart
lib/features/auth/presentation/pages/phone_page.dart
test/widget_test.dart            DELETE
test/helpers/pump_app.dart
test/helpers/fake_repositories.dart
test/... mirrors lib (listed per task)
```

---

### Task 1: `Result` and `Failure`

**Files:**
- Create: `lib/core/errors/failure.dart`, `lib/core/errors/result.dart`
- Test: `test/core/errors/result_test.dart`

**Interfaces:**
- Produces: `abstract interface class Failure`; `sealed class Result<T, E extends Failure>` with `isOk`, `valueOrNull`, `errorOrNull`; `Ok<T, E>(value)`, `Err<T, E>(error)`.

- [ ] **Step 1: Write the failing test**

`test/core/errors/result_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/failure.dart';
import 'package:j_donuts_app/core/errors/result.dart';

enum _TestFailure implements Failure { boom }

void main() {
  group('Result', () {
    test('Ok exposes its value and no error', () {
      const Result<int, _TestFailure> result = Ok(42);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, 42);
      expect(result.errorOrNull, isNull);
    });

    test('Err exposes its error and no value', () {
      const Result<int, _TestFailure> result = Err(_TestFailure.boom);

      expect(result.isOk, isFalse);
      expect(result.valueOrNull, isNull);
      expect(result.errorOrNull, _TestFailure.boom);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/errors/result_test.dart`
Expected: FAIL — compile error, `result.dart` not found.

- [ ] **Step 3: Write minimal implementation**

`lib/core/errors/failure.dart`
```dart
/// Marker for typed, expected failures carried inside a `Result`.
abstract interface class Failure {}
```

`lib/core/errors/result.dart`
```dart
import 'failure.dart';

sealed class Result<T, E extends Failure> {
  const Result();

  bool get isOk => this is Ok<T, E>;

  T? get valueOrNull => switch (this) {
        Ok<T, E>(:final value) => value,
        Err<T, E>() => null,
      };

  E? get errorOrNull => switch (this) {
        Ok<T, E>() => null,
        Err<T, E>(:final error) => error,
      };
}

final class Ok<T, E extends Failure> extends Result<T, E> {
  const Ok(this.value);

  final T value;
}

final class Err<T, E extends Failure> extends Result<T, E> {
  const Err(this.error);

  final E error;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/errors/result_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/core/errors test/core/errors
git commit -m "feat(core): add Result and Failure types"
```

---

### Task 2: `PhoneNumber` entity and phone validator

**Files:**
- Create: `lib/features/auth/domain/entities/phone_number.dart`, `lib/features/auth/domain/failures/phone_validation_failure.dart`, `lib/features/auth/domain/validators/phone_validator.dart`
- Test: `test/features/auth/domain/validators/phone_validator_test.dart`, `test/features/auth/domain/entities/phone_number_test.dart`

**Interfaces:**
- Consumes: `Result`, `Ok`, `Err`, `Failure` (Task 1).
- Produces: `PhoneNumber(String nationalNumber)` with `static const countryCode = '+95'`, `String get e164`, value equality; `enum PhoneValidationFailure implements Failure { empty, invalidFormat }`; `Result<PhoneNumber, PhoneValidationFailure> validatePhone(String raw)`.

- [ ] **Step 1: Write the failing tests**

`test/features/auth/domain/entities/phone_number_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';

void main() {
  test('e164 prefixes the national number with +95', () {
    expect(const PhoneNumber('9254135592').e164, '+959254135592');
  });

  test('numbers with the same national digits are equal', () {
    expect(const PhoneNumber('912345678'), const PhoneNumber('912345678'));
  });
}
```

`test/features/auth/domain/validators/phone_validator_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/failures/phone_validation_failure.dart';
import 'package:j_donuts_app/features/auth/domain/validators/phone_validator.dart';

void main() {
  String? e164Of(String raw) => validatePhone(raw).valueOrNull?.e164;
  PhoneValidationFailure? failureOf(String raw) =>
      validatePhone(raw).errorOrNull;

  group('validatePhone', () {
    test('rejects blank input as empty', () {
      expect(failureOf(''), PhoneValidationFailure.empty);
    });

    test('treats input of only spaces and dashes as empty', () {
      expect(failureOf(' - - '), PhoneValidationFailure.empty);
    });

    test('converts local format with leading zero to E.164', () {
      expect(e164Of('09254135592'), '+959254135592');
    });

    test('accepts a number typed without the leading zero', () {
      expect(e164Of('9254135592'), '+959254135592');
    });

    test('strips spaces and dashes before validating', () {
      expect(e164Of('09-254 135 592'), '+959254135592');
    });

    test('strips only one leading zero', () {
      expect(failureOf('009254135592'), PhoneValidationFailure.invalidFormat);
    });

    test('rejects numbers that do not start with 9', () {
      expect(failureOf('08254135592'), PhoneValidationFailure.invalidFormat);
    });

    test('rejects 6 digits after the 9', () {
      expect(failureOf('9123456'), PhoneValidationFailure.invalidFormat);
    });

    test('accepts 7 digits after the 9', () {
      expect(e164Of('91234567'), '+9591234567');
    });

    test('accepts 9 digits after the 9', () {
      expect(e164Of('9123456789'), '+959123456789');
    });

    test('rejects 10 digits after the 9', () {
      expect(failureOf('91234567890'), PhoneValidationFailure.invalidFormat);
    });

    test('rejects letters', () {
      expect(failureOf('09abc123456'), PhoneValidationFailure.invalidFormat);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/auth/domain`
Expected: FAIL — compile errors, files not found.

- [ ] **Step 3: Write minimal implementation**

`lib/features/auth/domain/entities/phone_number.dart`
```dart
/// A validated Myanmar mobile number, stored without country code.
final class PhoneNumber {
  const PhoneNumber(this.nationalNumber);

  static const countryCode = '+95';

  final String nationalNumber;

  String get e164 => '$countryCode$nationalNumber';

  @override
  bool operator ==(Object other) =>
      other is PhoneNumber && other.nationalNumber == nationalNumber;

  @override
  int get hashCode => nationalNumber.hashCode;
}
```

`lib/features/auth/domain/failures/phone_validation_failure.dart`
```dart
import '../../../../core/errors/failure.dart';

enum PhoneValidationFailure implements Failure { empty, invalidFormat }
```

`lib/features/auth/domain/validators/phone_validator.dart`
```dart
import '../../../../core/errors/result.dart';
import '../entities/phone_number.dart';
import '../failures/phone_validation_failure.dart';

final _separators = RegExp(r'[\s-]');
final _nationalNumberPattern = RegExp(r'^9\d{7,9}$');
const _trunkPrefix = '0';

Result<PhoneNumber, PhoneValidationFailure> validatePhone(String raw) {
  final digits = raw.replaceAll(_separators, '');
  if (digits.isEmpty) return const Err(PhoneValidationFailure.empty);

  final national =
      digits.startsWith(_trunkPrefix) ? digits.substring(1) : digits;
  if (!_nationalNumberPattern.hasMatch(national)) {
    return const Err(PhoneValidationFailure.invalidFormat);
  }
  return Ok(PhoneNumber(national));
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/auth/domain`
Expected: PASS (14 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/domain test/features/auth/domain
git commit -m "feat(auth): add phone number entity and validator"
```

---

### Task 3: Auth repository contract, `RequestOtp`, fake repository

**Files:**
- Create: `lib/features/auth/domain/entities/auth_flow.dart`, `lib/features/auth/domain/failures/auth_failure.dart`, `lib/features/auth/domain/repositories/auth_repository.dart`, `lib/features/auth/domain/usecases/request_otp.dart`, `lib/features/auth/data/repositories/fake_auth_repository.dart`, `test/helpers/fake_repositories.dart`
- Test: `test/features/auth/domain/usecases/request_otp_test.dart`, `test/features/auth/data/repositories/fake_auth_repository_test.dart`

**Interfaces:**
- Consumes: `PhoneNumber`, `Result` (Tasks 1–2).
- Produces:
  - `enum AuthFlow { register, login }`
  - `enum AuthFailure implements Failure { notRegistered, alreadyRegistered }`
  - `abstract interface class AuthRepository { Future<Result<void, AuthFailure>> requestOtp(PhoneNumber phone, {required AuthFlow flow}); }`
  - `class RequestOtp { const RequestOtp(AuthRepository); Future<Result<void, AuthFailure>> call(PhoneNumber phone, {required AuthFlow flow}); }`
  - `class FakeAuthRepository implements AuthRepository { FakeAuthRepository({Duration latency = defaultLatency, Set<String>? registeredNumbers}); static const defaultLatency = Duration(seconds: 1); }` — `registeredNumbers` holds E.164 strings.
  - Test helper `ControllableAuthRepository` with `int requestCount`, `void complete(Result<void, AuthFailure>)`.

- [ ] **Step 1: Write the failing tests**

`test/helpers/fake_repositories.dart`
```dart
import 'dart:async';

import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/repositories/auth_repository.dart';

/// Holds every request open until [complete] is called.
class ControllableAuthRepository implements AuthRepository {
  final _completer = Completer<Result<void, AuthFailure>>();
  int requestCount = 0;
  AuthFlow? lastFlow;

  @override
  Future<Result<void, AuthFailure>> requestOtp(
    PhoneNumber phone, {
    required AuthFlow flow,
  }) {
    requestCount++;
    lastFlow = flow;
    return _completer.future;
  }

  void complete(Result<void, AuthFailure> result) =>
      _completer.complete(result);
}
```

`test/features/auth/domain/usecases/request_otp_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/usecases/request_otp.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  test('forwards the phone and flow to the repository and returns its result',
      () async {
    final repository = ControllableAuthRepository();
    final requestOtp = RequestOtp(repository);

    final pending =
        requestOtp(const PhoneNumber('9254135592'), flow: AuthFlow.login);
    repository.complete(const Err(AuthFailure.notRegistered));

    expect((await pending).errorOrNull, AuthFailure.notRegistered);
    expect(repository.requestCount, 1);
    expect(repository.lastFlow, AuthFlow.login);
  });
}
```

`test/features/auth/data/repositories/fake_auth_repository_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';

void main() {
  const known = PhoneNumber('9254135592');
  const unknown = PhoneNumber('912345678');

  FakeAuthRepository build() => FakeAuthRepository(
        latency: Duration.zero,
        registeredNumbers: {known.e164},
      );

  test('registering a new number succeeds', () async {
    final result = await build().requestOtp(unknown, flow: AuthFlow.register);
    expect(result.isOk, isTrue);
  });

  test('registering an existing number fails as already registered', () async {
    final result = await build().requestOtp(known, flow: AuthFlow.register);
    expect(result.errorOrNull, AuthFailure.alreadyRegistered);
  });

  test('logging in with an unknown number fails as not registered', () async {
    final result = await build().requestOtp(unknown, flow: AuthFlow.login);
    expect(result.errorOrNull, AuthFailure.notRegistered);
  });

  test('logging in with a registered number succeeds', () async {
    final result = await build().requestOtp(known, flow: AuthFlow.login);
    expect(result.isOk, isTrue);
  });

  test('defaults to a one second fake latency', () {
    expect(FakeAuthRepository.defaultLatency, const Duration(seconds: 1));
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/auth/domain/usecases test/features/auth/data`
Expected: FAIL — compile errors, files not found.

- [ ] **Step 3: Write minimal implementation**

`lib/features/auth/domain/entities/auth_flow.dart`
```dart
enum AuthFlow { register, login }
```

`lib/features/auth/domain/failures/auth_failure.dart`
```dart
import '../../../../core/errors/failure.dart';

enum AuthFailure implements Failure { notRegistered, alreadyRegistered }
```

`lib/features/auth/domain/repositories/auth_repository.dart`
```dart
import '../../../../core/errors/result.dart';
import '../entities/auth_flow.dart';
import '../entities/phone_number.dart';
import '../failures/auth_failure.dart';

abstract interface class AuthRepository {
  Future<Result<void, AuthFailure>> requestOtp(
    PhoneNumber phone, {
    required AuthFlow flow,
  });
}
```

`lib/features/auth/domain/usecases/request_otp.dart`
```dart
import '../../../../core/errors/result.dart';
import '../entities/auth_flow.dart';
import '../entities/phone_number.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

class RequestOtp {
  const RequestOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<void, AuthFailure>> call(
    PhoneNumber phone, {
    required AuthFlow flow,
  }) =>
      _repository.requestOtp(phone, flow: flow);
}
```

`lib/features/auth/data/repositories/fake_auth_repository.dart`
```dart
import '../../../../core/errors/result.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/entities/phone_number.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';

/// Simulates a backend: waits [latency], keeps registered numbers in memory.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.latency = defaultLatency,
    Set<String>? registeredNumbers,
  }) : _registeredNumbers = registeredNumbers ?? <String>{};

  static const defaultLatency = Duration(seconds: 1);

  final Duration latency;
  final Set<String> _registeredNumbers;

  @override
  Future<Result<void, AuthFailure>> requestOtp(
    PhoneNumber phone, {
    required AuthFlow flow,
  }) async {
    await Future<void>.delayed(latency);
    final isRegistered = _registeredNumbers.contains(phone.e164);
    return switch (flow) {
      AuthFlow.login when !isRegistered => const Err(AuthFailure.notRegistered),
      AuthFlow.register when isRegistered =>
        const Err(AuthFailure.alreadyRegistered),
      _ => const Ok(null),
    };
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/auth/domain/usecases test/features/auth/data`
Expected: PASS (6 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/domain lib/features/auth/data test/helpers test/features/auth/domain/usecases test/features/auth/data
git commit -m "feat(auth): add AuthRepository, RequestOtp and fake repository"
```

---

### Task 4: Phone step state management

**Files:**
- Create: `lib/features/auth/presentation/providers/auth_providers.dart`, `.../auth_draft_notifier.dart`, `.../phone_step_state.dart`, `.../phone_step_notifier.dart`
- Test: `test/features/auth/presentation/providers/phone_step_notifier_test.dart`

**Interfaces:**
- Consumes: Tasks 1–3.
- Produces:
  - `final authRepositoryProvider = Provider<AuthRepository>(...)` (default `FakeAuthRepository()`)
  - `final requestOtpProvider = Provider<RequestOtp>(...)`
  - `class AuthDraft { final String phoneInput; }`, `final authDraftProvider = NotifierProvider<AuthDraftNotifier, AuthDraft>(...)`, `AuthDraftNotifier.updatePhoneInput(String)`
  - `sealed class PhoneSubmitStatus` with `PhoneSubmitIdle`, `PhoneSubmitting`, `PhoneSubmitSuccess(PhoneNumber phone)`, `PhoneSubmitFailure(AuthFailure failure)`
  - `class PhoneStepState { String input; Result<PhoneNumber, PhoneValidationFailure> validation; PhoneSubmitStatus status; bool canSubmit; bool isSubmitting; PhoneValidationFailure? visibleError; }`
  - `final phoneStepProvider = NotifierProvider.autoDispose.family<PhoneStepNotifier, PhoneStepState, AuthFlow>(PhoneStepNotifier.new)`; methods `onInputChanged(String)`, `Future<void> submit()`

- [ ] **Step 1: Write the failing test**

`test/features/auth/presentation/providers/phone_step_notifier_test.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/phone_validation_failure.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/phone_step_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/phone_step_state.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  const validInput = '09254135592';
  final provider = phoneStepProvider(AuthFlow.register);
  late ControllableAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = ControllableAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(provider, (_, _) {});
  });

  PhoneStepState state() => container.read(provider);
  PhoneStepNotifier notifier() => container.read(provider.notifier);

  test('starts empty and cannot submit', () {
    expect(state().input, isEmpty);
    expect(state().canSubmit, isFalse);
    expect(state().visibleError, isNull);
  });

  test('restores input from the shared draft', () {
    final fresh = ProviderContainer.test();
    fresh.read(authDraftProvider.notifier).updatePhoneInput(validInput);

    expect(fresh.read(provider).input, validInput);
    expect(fresh.read(provider).canSubmit, isTrue);
  });

  test('input change revalidates and saves the draft', () {
    notifier().onInputChanged(validInput);

    expect(state().canSubmit, isTrue);
    expect(container.read(authDraftProvider).phoneInput, validInput);
  });

  test('exposes a format error only for non-empty invalid input', () {
    notifier().onInputChanged('0912');
    expect(state().visibleError, PhoneValidationFailure.invalidFormat);

    notifier().onInputChanged('');
    expect(state().visibleError, isNull);
  });

  test('submit is ignored while the number is invalid', () async {
    notifier().onInputChanged('0912');
    await notifier().submit();

    expect(repository.requestCount, 0);
  });

  test('submit shows submitting then success with the phone number', () async {
    notifier().onInputChanged(validInput);
    final pending = notifier().submit();

    expect(state().isSubmitting, isTrue);
    expect(state().canSubmit, isFalse);

    repository.complete(const Ok(null));
    await pending;

    final status = state().status;
    expect(status, isA<PhoneSubmitSuccess>());
    expect((status as PhoneSubmitSuccess).phone, const PhoneNumber('9254135592'));
  });

  test('a second submit while submitting sends no extra request', () async {
    notifier().onInputChanged(validInput);
    final first = notifier().submit();
    final second = notifier().submit();
    repository.complete(const Ok(null));
    await Future.wait([first, second]);

    expect(repository.requestCount, 1);
  });

  test('submit failure exposes the auth failure', () async {
    notifier().onInputChanged(validInput);
    final pending = notifier().submit();
    repository.complete(const Err(AuthFailure.alreadyRegistered));
    await pending;

    final status = state().status;
    expect(status, isA<PhoneSubmitFailure>());
    expect((status as PhoneSubmitFailure).failure, AuthFailure.alreadyRegistered);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/auth/presentation/providers`
Expected: FAIL — compile errors, providers not found.

- [ ] **Step 3: Write minimal implementation**

`lib/features/auth/presentation/providers/auth_providers.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fake_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/request_otp.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => FakeAuthRepository());

final requestOtpProvider =
    Provider<RequestOtp>((ref) => RequestOtp(ref.watch(authRepositoryProvider)));
```

`lib/features/auth/presentation/providers/auth_draft_notifier.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Input kept across auth steps so Back never loses what was typed.
class AuthDraft {
  const AuthDraft({this.phoneInput = ''});

  final String phoneInput;

  AuthDraft copyWith({String? phoneInput}) =>
      AuthDraft(phoneInput: phoneInput ?? this.phoneInput);
}

class AuthDraftNotifier extends Notifier<AuthDraft> {
  @override
  AuthDraft build() => const AuthDraft();

  void updatePhoneInput(String value) =>
      state = state.copyWith(phoneInput: value);
}

final authDraftProvider =
    NotifierProvider<AuthDraftNotifier, AuthDraft>(AuthDraftNotifier.new);
```

`lib/features/auth/presentation/providers/phone_step_state.dart`
```dart
import '../../../../core/errors/result.dart';
import '../../domain/entities/phone_number.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/failures/phone_validation_failure.dart';

sealed class PhoneSubmitStatus {
  const PhoneSubmitStatus();
}

final class PhoneSubmitIdle extends PhoneSubmitStatus {
  const PhoneSubmitIdle();
}

final class PhoneSubmitting extends PhoneSubmitStatus {
  const PhoneSubmitting();
}

final class PhoneSubmitSuccess extends PhoneSubmitStatus {
  const PhoneSubmitSuccess(this.phone);

  final PhoneNumber phone;
}

final class PhoneSubmitFailure extends PhoneSubmitStatus {
  const PhoneSubmitFailure(this.failure);

  final AuthFailure failure;
}

class PhoneStepState {
  const PhoneStepState({
    required this.input,
    required this.validation,
    this.status = const PhoneSubmitIdle(),
  });

  final String input;
  final Result<PhoneNumber, PhoneValidationFailure> validation;
  final PhoneSubmitStatus status;

  bool get isSubmitting => status is PhoneSubmitting;

  bool get canSubmit => validation.isOk && !isSubmitting;

  /// Error worth telling the user about; nothing while the field is untouched.
  PhoneValidationFailure? get visibleError =>
      input.isEmpty ? null : validation.errorOrNull;

  PhoneStepState copyWith({
    String? input,
    Result<PhoneNumber, PhoneValidationFailure>? validation,
    PhoneSubmitStatus? status,
  }) =>
      PhoneStepState(
        input: input ?? this.input,
        validation: validation ?? this.validation,
        status: status ?? this.status,
      );
}
```

`lib/features/auth/presentation/providers/phone_step_notifier.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/validators/phone_validator.dart';
import 'auth_draft_notifier.dart';
import 'auth_providers.dart';
import 'phone_step_state.dart';

class PhoneStepNotifier extends Notifier<PhoneStepState> {
  PhoneStepNotifier(this.flow);

  final AuthFlow flow;

  @override
  PhoneStepState build() {
    final input = ref.read(authDraftProvider).phoneInput;
    return PhoneStepState(input: input, validation: validatePhone(input));
  }

  void onInputChanged(String input) {
    ref.read(authDraftProvider.notifier).updatePhoneInput(input);
    state = state.copyWith(
      input: input,
      validation: validatePhone(input),
      status: const PhoneSubmitIdle(),
    );
  }

  Future<void> submit() async {
    final phone = state.validation.valueOrNull;
    if (phone == null || state.isSubmitting) return;

    state = state.copyWith(status: const PhoneSubmitting());
    final result = await ref.read(requestOtpProvider)(phone, flow: flow);
    if (!ref.mounted) return;

    state = state.copyWith(
      status: switch (result) {
        Ok() => PhoneSubmitSuccess(phone),
        Err(:final error) => PhoneSubmitFailure(error),
      },
    );
  }
}

final phoneStepProvider = NotifierProvider.autoDispose
    .family<PhoneStepNotifier, PhoneStepState, AuthFlow>(PhoneStepNotifier.new);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/auth/presentation/providers`
Expected: PASS (8 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/presentation/providers test/features/auth/presentation/providers
git commit -m "feat(auth): add phone step notifier with shared draft"
```

---

### Task 5: Design system foundation — tokens, l10n, toast, primary button

**Files:**
- Modify: `pubspec.yaml` (flutter section), `analysis_options.yaml`
- Create: `l10n.yaml`, `lib/l10n/app_en.arb`, `lib/core/l10n/l10n_extension.dart`, `lib/core/constants/app_colors.dart`, `lib/core/constants/app_dimens.dart`, `lib/core/constants/app_motion.dart`, `lib/core/theme/app_text_styles.dart`, `lib/core/theme/app_theme.dart`, `lib/core/widgets/gradient_background.dart`, `lib/core/widgets/app_toast.dart`, `lib/core/widgets/primary_button.dart`, `test/helpers/pump_app.dart`
- Delete: `test/widget_test.dart` (counter template; breaks once `main.dart` changes)
- Test: `test/core/widgets/primary_button_test.dart`, `test/core/widgets/app_toast_test.dart`

**Interfaces:**
- Produces:
  - `context.l10n` (`AppLocalizations`, non-null) from `l10n_extension.dart`; generated `package:j_donuts_app/l10n/app_localizations.dart` with `lookupAppLocalizations(Locale)`.
  - `AppColors.*`, `AppDimens.*`, `AppTextStyles.*`, `AppTheme.light`
  - `AppMotion.short|medium|long|toastDisplay|standardCurve|pressedScale`, `AppMotion.of(BuildContext, Duration)` → `Duration.zero` under Reduce Motion
  - `GradientBackground({required Widget child, List<Color> colors = AppColors.authGradient})`
  - `enum AppToastType { info, error }`; `AppToast.show(BuildContext, {required String message, AppToastType type, String? actionLabel, VoidCallback? onAction})`
  - `PrimaryButton({required String label, required VoidCallback? onPressed, bool isLoading = false})` — label rendered upper-case; `onPressed == null` and not loading = disabled look
  - Test helper `tester.pumpApp(Widget child)`

- [ ] **Step 1: Project config (no test cycle — needed by the widget tests)**

`pubspec.yaml` — replace the `flutter:` section (keep comments out):
```yaml
flutter:
  generate: true
  uses-material-design: true
  fonts:
    - family: Urbanist
      fonts:
        - asset: assets/fonts/Urbanist-400.ttf
          weight: 400
        - asset: assets/fonts/Urbanist-500.ttf
          weight: 500
        - asset: assets/fonts/Urbanist-600.ttf
          weight: 600
        - asset: assets/fonts/Urbanist-700.ttf
          weight: 700
        - asset: assets/fonts/Urbanist-800.ttf
          weight: 800
```

`l10n.yaml`
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
nullable-getter: false
```

`analysis_options.yaml`
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_single_quotes: true
    prefer_final_locals: true
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
```

`lib/l10n/app_en.arb`
```json
{
  "@@locale": "en",
  "appName": "J'Donuts",
  "getStarted": "Let's get started",
  "alreadyHaveAccount": "Already have an account?",
  "logIn": "Log In",
  "continueWithGoogle": "Continue with Google",
  "continueWithFacebook": "Continue with Facebook",
  "legalNoticePrefix": "By continuing, you acknowledge that you have read and agree to our ",
  "termsOfUse": "Terms of Use",
  "legalNoticeConjunction": " and ",
  "privacyPolicy": "Privacy Policy",
  "legalNoticeSuffix": ".",
  "comingSoon": "Coming soon",
  "back": "Back",
  "stepProgress": "Step {current} of {total}",
  "@stepProgress": {
    "placeholders": {
      "current": {"type": "int"},
      "total": {"type": "int"}
    }
  },
  "phoneTitle": "Enter your phone number",
  "phoneHint": "9 xxx xxx xxx",
  "continueLabel": "Continue",
  "phoneErrorEmpty": "Please enter your phone number.",
  "phoneErrorInvalid": "Enter a valid Myanmar mobile number, like 09 123 456 789.",
  "authErrorNotRegistered": "This number isn't registered yet.",
  "authErrorAlreadyRegistered": "This number is already registered. Please log in.",
  "registerAction": "Register",
  "verifyNumberTitle": "Verify your number"
}
```

Run: `git rm test/widget_test.dart; flutter pub get; flutter gen-l10n`
Expected: generates `lib/l10n/app_localizations.dart` and `lib/l10n/app_localizations_en.dart`, no errors.

- [ ] **Step 2: Write the failing tests**

`test/helpers/pump_app.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/theme/app_theme.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
  /// Pumps [child] inside a themed, localized app with a Scaffold.
  Future<void> pumpApp(Widget child) => pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        ),
      );
}
```

`test/core/widgets/primary_button_test.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the label in upper case', (tester) async {
    await tester.pumpApp(PrimaryButton(label: 'Continue', onPressed: () {}));

    expect(find.text('CONTINUE'), findsOneWidget);
  });

  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await tester.pumpApp(PrimaryButton(label: 'Go', onPressed: () => taps++));

    await tester.tap(find.byType(PrimaryButton));

    expect(taps, 1);
  });

  testWidgets('shows a spinner and ignores taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      PrimaryButton(label: 'Go', onPressed: () => taps++, isLoading: true),
    );
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byType(PrimaryButton));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('GO'), findsNothing);
    expect(taps, 0);
  });
}
```

`test/core/widgets/app_toast_test.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/widgets/app_toast.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<void> showToast(
    WidgetTester tester, {
    String? actionLabel,
    VoidCallback? onAction,
  }) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => AppToast.show(
            context,
            message: 'Something went wrong',
            type: AppToastType.error,
            actionLabel: actionLabel,
            onAction: onAction,
          ),
          child: const Text('trigger'),
        ),
      ),
    );
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the message with an error icon', (tester) async {
    await showToast(tester);

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.byIcon(Icons.error_rounded), findsOneWidget);
  });

  testWidgets('runs the action when its label is tapped', (tester) async {
    var actions = 0;
    await showToast(tester, actionLabel: 'Retry', onAction: () => actions++);

    await tester.tap(find.text('Retry'));

    expect(actions, 1);
  });

  testWidgets('a new toast replaces the visible one', (tester) async {
    await showToast(tester);
    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test test/core/widgets`
Expected: FAIL — compile errors, `app_theme.dart` / widgets not found.

- [ ] **Step 4: Write minimal implementation**

`lib/core/l10n/l10n_extension.dart`
```dart
import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
```

`lib/core/constants/app_colors.dart`
```dart
import 'package:flutter/painting.dart';

/// Brand palette sampled from the J'Donuts designs.
abstract final class AppColors {
  static const primary = Color(0xFF32C4E9);
  static const primaryDisabled = Color(0x8032C4E9);
  static const onPrimary = Color(0xFFFFFFFF);
  static const accent = Color(0xFFF2559A);
  static const ringProgress = Color(0xFFFF4C9E);
  static const ringTrack = Color(0xFF61D3F8);
  static const backgroundTop = Color(0xFFFFD6E6);
  static const backgroundMiddle = Color(0xFFFFECF2);
  static const backgroundBottom = Color(0xFFFFF7FA);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1E1E22);
  static const textHint = Color(0xFF999999);
  static const textMuted = Color(0xFF787677);
  static const error = Color(0xFFE5484D);
  static const shadow = Color(0x14000000);
  static const facebookBlue = Color(0xFF1877F2);
  static const heroCyan = Color(0xFFB8ECF8);
  static const heroPink = Color(0xFFFFD9E8);
  static const heroLavender = Color(0xFFDCD6FF);
  static const heroPeach = Color(0xFFFCE3D6);

  static const authGradient = [backgroundTop, backgroundMiddle, backgroundBottom];
  static const onboardingGradient = [surface, backgroundBottom];
}
```

`lib/core/constants/app_dimens.dart`
```dart
abstract final class AppDimens {
  static const spaceXs = 4.0;
  static const spaceSm = 8.0;
  static const spaceMd = 16.0;
  static const spaceLg = 24.0;
  static const spaceXl = 32.0;

  static const screenPadding = 32.0;
  static const onboardingPadding = 20.0;

  static const buttonHeight = 52.0;
  static const inputHeight = 68.0;
  static const inputRadius = 10.0;
  static const backButtonSize = 40.0;
  static const backButtonRadius = 10.0;
  static const progressRingSize = 40.0;
  static const progressRingStroke = 9.0;
  static const socialButtonSize = 48.0;
  static const toastRadius = 16.0;
  static const toastElevation = 6.0;
  static const spinnerSize = 22.0;
  static const spinnerStroke = 2.5;
  static const iconMd = 24.0;
  static const iconLg = 32.0;
  static const shadowBlur = 12.0;
}
```

`lib/core/constants/app_motion.dart`
```dart
import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 300);
  static const long = Duration(milliseconds: 600);
  static const toastDisplay = Duration(seconds: 3);

  static const standardCurve = Curves.easeOutCubic;
  static const pressedScale = 0.96;

  /// [duration], or zero when the user asked to reduce motion.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
```

`lib/core/theme/app_text_styles.dart`
```dart
import 'package:flutter/painting.dart';

import '../constants/app_colors.dart';

abstract final class AppTextStyles {
  static const fontFamily = 'Urbanist';

  static const headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
  static const input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
  );
  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.4,
    color: AppColors.onPrimary,
  );
  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textMuted,
  );
  static const captionLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.accent,
  );
  static const toast = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );
  static const brand = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
  );
}
```

`lib/core/theme/app_theme.dart`
```dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppTextStyles.fontFamily,
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: AppColors.accent),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.surface,
          elevation: AppDimens.toastElevation,
          contentTextStyle: AppTextStyles.toast,
          actionTextColor: AppColors.accent,
          insetPadding: const EdgeInsets.all(AppDimens.spaceLg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.toastRadius),
          ),
        ),
      );
}
```

`lib/core/widgets/gradient_background.dart`
```dart
import 'package:flutter/widgets.dart';

import '../constants/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.colors = AppColors.authGradient,
  });

  final Widget child;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
```

`lib/core/widgets/app_toast.dart`
```dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_motion.dart';
import '../theme/app_text_styles.dart';

enum AppToastType { info, error }

/// Short floating message; replaces any toast already on screen.
abstract final class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final action = actionLabel == null
        ? null
        : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: AppMotion.toastDisplay,
          content: _ToastContent(message: message, type: type),
          action: action,
        ),
      );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({required this.message, required this.type});

  final String message;
  final AppToastType type;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      AppToastType.info => (Icons.info_rounded, AppColors.primary),
      AppToastType.error => (Icons.error_rounded, AppColors.error),
    };
    return Row(
      children: [
        Icon(icon, color: color, size: AppDimens.iconMd),
        const SizedBox(width: AppDimens.spaceSm),
        Expanded(child: Text(message, style: AppTextStyles.toast)),
      ],
    );
  }
}
```

`lib/core/widgets/primary_button.dart`
```dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_motion.dart';
import '../theme/app_text_styles.dart';

/// Pill button that scales on press and morphs into a spinner while loading.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _setPressed(bool pressed) {
    if (_pressed != pressed) setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.medium);
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: () => _setPressed(false),
        onTap: _enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed ? AppMotion.pressedScale : 1,
          duration: AppMotion.of(context, AppMotion.short),
          child: _ButtonBody(
            label: widget.label,
            isLoading: widget.isLoading,
            isDisabled: widget.onPressed == null && !widget.isLoading,
            duration: duration,
          ),
        ),
      ),
    );
  }
}

class _ButtonBody extends StatelessWidget {
  const _ButtonBody({
    required this.label,
    required this.isLoading,
    required this.isDisabled,
    required this.duration,
  });

  final String label;
  final bool isLoading;
  final bool isDisabled;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: AnimatedContainer(
          duration: duration,
          curve: AppMotion.standardCurve,
          height: AppDimens.buttonHeight,
          width: isLoading ? AppDimens.buttonHeight : constraints.maxWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDisabled ? AppColors.primaryDisabled : AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimens.buttonHeight / 2),
          ),
          child: AnimatedSwitcher(
            duration: duration,
            child: isLoading
                ? const _Spinner()
                : Text(
                    label.toUpperCase(),
                    key: ValueKey(label),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: AppTextStyles.button,
                  ),
          ),
        ),
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: AppDimens.spinnerSize,
      child: CircularProgressIndicator(
        strokeWidth: AppDimens.spinnerStroke,
        color: AppColors.onPrimary,
      ),
    );
  }
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/core`
Expected: PASS (8 tests).

- [ ] **Step 6: Analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock l10n.yaml analysis_options.yaml assets/fonts lib/l10n lib/core test/helpers/pump_app.dart test/core/widgets
git commit -m "feat(core): add design tokens, l10n, toast and primary button"
```

---

### Task 6: Step progress ring

**Files:**
- Create: `lib/features/auth/presentation/widgets/step_progress_ring.dart`
- Test: `test/features/auth/presentation/widgets/step_progress_ring_test.dart`

**Interfaces:**
- Consumes: `AppColors`, `AppDimens`, `AppMotion`, `context.l10n.stepProgress(int, int)`.
- Produces: `StepProgressRing({required int currentStep, required int totalSteps})`; `StepProgressPainter({required double progress})` with public `progress`.

- [ ] **Step 1: Write the failing test**

`test/features/auth/presentation/widgets/step_progress_ring_test.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  double paintedProgress(WidgetTester tester) {
    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(StepProgressRing),
        matching: find.byType(CustomPaint),
      ),
    );
    return (paint.painter! as StepProgressPainter).progress;
  }

  testWidgets('animates from the previous step to the current step',
      (tester) async {
    await tester.pumpApp(
      const StepProgressRing(currentStep: 2, totalSteps: 4),
    );
    expect(paintedProgress(tester), 0.25);

    await tester.pumpAndSettle();
    expect(paintedProgress(tester), 0.5);
  });

  testWidgets('jumps straight to the current step when motion is reduced',
      (tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: const StepProgressRing(currentStep: 1, totalSteps: 4),
        ),
      ),
    );

    expect(paintedProgress(tester), 0.25);
  });

  testWidgets('announces the step to screen readers', (tester) async {
    await tester.pumpApp(
      const StepProgressRing(currentStep: 1, totalSteps: 4),
    );

    expect(find.bySemanticsLabel('Step 1 of 4'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/auth/presentation/widgets/step_progress_ring_test.dart`
Expected: FAIL — compile error, file not found.

- [ ] **Step 3: Write minimal implementation**

`lib/features/auth/presentation/widgets/step_progress_ring.dart`
```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';

/// Donut ring in the top-right of each registration step.
class StepProgressRing extends StatelessWidget {
  const StepProgressRing({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.stepProgress(currentStep, totalSteps),
      child: SizedBox.square(
        dimension: AppDimens.progressRingSize,
        child: TweenAnimationBuilder<double>(
          tween: Tween(
            begin: (currentStep - 1) / totalSteps,
            end: currentStep / totalSteps,
          ),
          duration: AppMotion.of(context, AppMotion.long),
          curve: AppMotion.standardCurve,
          builder: (context, progress, _) =>
              CustomPaint(painter: StepProgressPainter(progress: progress)),
        ),
      ),
    );
  }
}

class StepProgressPainter extends CustomPainter {
  StepProgressPainter({required this.progress});

  static const _startAngle = -math.pi / 2;
  static const _fullTurn = 2 * math.pi;

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = AppDimens.progressRingStroke;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(rect, 0, _fullTurn, false, paint..color = AppColors.ringTrack);
    canvas.drawArc(
      rect,
      _startAngle,
      _fullTurn * progress,
      false,
      paint..color = AppColors.ringProgress,
    );
  }

  @override
  bool shouldRepaint(StepProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/auth/presentation/widgets/step_progress_ring_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/presentation/widgets/step_progress_ring.dart test/features/auth/presentation/widgets/step_progress_ring_test.dart
git commit -m "feat(auth): add animated step progress ring"
```

---

### Task 7: Auth step building blocks — back button, legal footer, phone field, step scaffold, failure messages

**Files:**
- Create: `lib/features/auth/presentation/widgets/auth_back_button.dart`, `.../legal_footer.dart`, `.../phone_input_field.dart`, `.../auth_step_scaffold.dart`, `lib/features/auth/presentation/mappers/failure_messages.dart`
- Test: `test/features/auth/presentation/widgets/legal_footer_test.dart`, `test/features/auth/presentation/widgets/phone_input_field_test.dart`, `test/features/auth/presentation/mappers/failure_messages_test.dart`

**Interfaces:**
- Consumes: Task 5 tokens/toast, Task 6 ring, `PhoneNumber.countryCode`, failures enums.
- Produces:
  - `AuthBackButton({required VoidCallback onPressed})`
  - `LegalFooter({required VoidCallback onTermsTap, required VoidCallback onPrivacyTap})`
  - `PhoneInputField({required TextEditingController controller, required FocusNode focusNode, required ValueChanged<String> onChanged, required ValueChanged<String> onSubmitted, bool readOnly = false})` — unfocuses on tap outside
  - `AuthStepScaffold({required String title, required Widget body, required Widget action, required VoidCallback onBack, int? currentStep})`, `static const registrationStepCount = 4`
  - `extension PhoneValidationFailureMessage on PhoneValidationFailure { String message(AppLocalizations) }`, `extension AuthFailureMessage on AuthFailure { String message(AppLocalizations) }`

- [ ] **Step 1: Write the failing tests**

`test/features/auth/presentation/mappers/failure_messages_test.dart`
```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/failures/phone_validation_failure.dart';
import 'package:j_donuts_app/features/auth/presentation/mappers/failure_messages.dart';
import 'package:j_donuts_app/l10n/app_localizations.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('maps phone validation failures to localized text', () {
    expect(PhoneValidationFailure.empty.message(l10n), l10n.phoneErrorEmpty);
    expect(
      PhoneValidationFailure.invalidFormat.message(l10n),
      l10n.phoneErrorInvalid,
    );
  });

  test('maps auth failures to localized text', () {
    expect(AuthFailure.notRegistered.message(l10n), l10n.authErrorNotRegistered);
    expect(
      AuthFailure.alreadyRegistered.message(l10n),
      l10n.authErrorAlreadyRegistered,
    );
  });
}
```

`test/features/auth/presentation/widgets/legal_footer_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/legal_footer.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tapping each link calls its own callback', (tester) async {
    final taps = <String>[];
    await tester.pumpApp(
      LegalFooter(
        onTermsTap: () => taps.add('terms'),
        onPrivacyTap: () => taps.add('privacy'),
      ),
    );

    await tester.tapOnText(find.textRange.ofSubstring('Terms of Use'));
    await tester.tapOnText(find.textRange.ofSubstring('Privacy Policy'));

    expect(taps, ['terms', 'privacy']);
  });
}
```

`test/features/auth/presentation/widgets/phone_input_field_test.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/phone_input_field.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });

  tearDown(() {
    controller.dispose();
    focusNode.dispose();
  });

  Future<void> pumpField(WidgetTester tester) => tester.pumpApp(
        PhoneInputField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (_) {},
          onSubmitted: (_) {},
        ),
      );

  testWidgets('shows the +95 country code prefix', (tester) async {
    await pumpField(tester);

    expect(find.text('+95'), findsOneWidget);
  });

  testWidgets('keeps only digits, spaces and dashes', (tester) async {
    await pumpField(tester);

    await tester.enterText(find.byType(TextField), 'a9-25 4x');

    expect(controller.text, '9-25 4');
  });

  testWidgets('loses focus when the user taps outside', (tester) async {
    await pumpField(tester);
    await tester.tap(find.byType(TextField));
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(5, 500));

    expect(focusNode.hasFocus, isFalse);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/auth/presentation/widgets/legal_footer_test.dart test/features/auth/presentation/widgets/phone_input_field_test.dart test/features/auth/presentation/mappers`
Expected: FAIL — compile errors, files not found.

- [ ] **Step 3: Write minimal implementation**

`lib/features/auth/presentation/mappers/failure_messages.dart`
```dart
import '../../../../l10n/app_localizations.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/failures/phone_validation_failure.dart';

extension PhoneValidationFailureMessage on PhoneValidationFailure {
  String message(AppLocalizations l10n) => switch (this) {
        PhoneValidationFailure.empty => l10n.phoneErrorEmpty,
        PhoneValidationFailure.invalidFormat => l10n.phoneErrorInvalid,
      };
}

extension AuthFailureMessage on AuthFailure {
  String message(AppLocalizations l10n) => switch (this) {
        AuthFailure.notRegistered => l10n.authErrorNotRegistered,
        AuthFailure.alreadyRegistered => l10n.authErrorAlreadyRegistered,
      };
}
```

`lib/features/auth/presentation/widgets/auth_back_button.dart`
```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimens.backButtonRadius);
    return Tooltip(
      message: context.l10n.back,
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: const SizedBox.square(
            dimension: AppDimens.backButtonSize,
            child: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: AppDimens.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}
```

`lib/features/auth/presentation/widgets/legal_footer.dart`
```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class LegalFooter extends StatefulWidget {
  const LegalFooter({
    super.key,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  @override
  State<LegalFooter> createState() => _LegalFooterState();
}

class _LegalFooterState extends State<LegalFooter> {
  late final _termsRecognizer = TapGestureRecognizer()
    ..onTap = () => widget.onTermsTap();
  late final _privacyRecognizer = TapGestureRecognizer()
    ..onTap = () => widget.onPrivacyTap();

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        style: AppTextStyles.caption,
        children: [
          TextSpan(text: l10n.legalNoticePrefix),
          TextSpan(
            text: l10n.termsOfUse,
            style: AppTextStyles.captionLink,
            recognizer: _termsRecognizer,
          ),
          TextSpan(text: l10n.legalNoticeConjunction),
          TextSpan(
            text: l10n.privacyPolicy,
            style: AppTextStyles.captionLink,
            recognizer: _privacyRecognizer,
          ),
          TextSpan(text: l10n.legalNoticeSuffix),
        ],
      ),
    );
  }
}
```

`lib/features/auth/presentation/widgets/phone_input_field.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/phone_number.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    this.readOnly = false,
  });

  static const _maxInputLength = 15;
  static final _allowedCharacters = RegExp(r'[0-9 \-]');

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppDimens.inputHeight),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      ),
      child: Row(
        children: [
          const Text(PhoneNumber.countryCode, style: AppTextStyles.inputHint),
          const SizedBox(width: AppDimens.spaceLg),
          Expanded(child: _buildTextField(context)),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [
        FilteringTextInputFormatter.allow(_allowedCharacters),
        LengthLimitingTextInputFormatter(_maxInputLength),
      ],
      style: AppTextStyles.input,
      decoration: InputDecoration.collapsed(
        hintText: context.l10n.phoneHint,
        hintStyle: AppTextStyles.inputHint,
      ),
      onTapOutside: (_) => focusNode.unfocus(),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
```

`lib/features/auth/presentation/widgets/auth_step_scaffold.dart`
```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/gradient_background.dart';
import 'auth_back_button.dart';
import 'legal_footer.dart';
import 'step_progress_ring.dart';

/// Shared layout of every auth step: header, title, body, action, legal.
class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.action,
    required this.onBack,
    this.currentStep,
  });

  static const registrationStepCount = 4;

  final String title;
  final Widget body;
  final Widget action;
  final VoidCallback onBack;

  /// Registration step (1-based); null hides the progress ring.
  final int? currentStep;

  void _showComingSoon(BuildContext context) =>
      AppToast.show(context, message: context.l10n.comingSoon);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.screenPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(child: _buildContent(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final step = currentStep;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.spaceLg),
        Row(
          children: [
            TextFieldTapRegion(child: AuthBackButton(onPressed: onBack)),
            const Spacer(),
            if (step != null)
              StepProgressRing(
                currentStep: step,
                totalSteps: registrationStepCount,
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXl),
        Text(title, style: AppTextStyles.headline),
        const SizedBox(height: AppDimens.spaceXl),
        body,
        const Spacer(),
        const SizedBox(height: AppDimens.spaceLg),
        action,
        const SizedBox(height: AppDimens.spaceLg),
        LegalFooter(
          onTermsTap: () => _showComingSoon(context),
          onPrivacyTap: () => _showComingSoon(context),
        ),
        const SizedBox(height: AppDimens.spaceMd),
      ],
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/auth/presentation`
Expected: PASS (all presentation tests so far: 8 provider + 3 ring + 6 new = 17).

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/presentation test/features/auth/presentation
git commit -m "feat(auth): add auth step scaffold, phone field and legal footer"
```

---

### Task 8: Phone page, router, app shell

**Files:**
- Create: `lib/core/router/app_routes.dart`, `lib/core/router/app_router.dart`, `lib/core/widgets/placeholder_page.dart`, `lib/features/auth/presentation/auth_routes.dart`, `lib/features/auth/presentation/pages/phone_page.dart`, `lib/features/auth/presentation/pages/onboarding_page.dart` (temporary minimal version, completed in Task 9), `lib/app.dart`, `test/helpers/pump_jdonuts_app.dart`
- Replace: `lib/main.dart`
- Test: `test/features/auth/presentation/pages/phone_page_test.dart`

**Interfaces:**
- Consumes: everything above.
- Produces:
  - `AppRoutes.onboarding = '/'`, `registerPhone = '/register/phone'`, `loginPhone = '/login/phone'`, `registerOtp = '/register/otp'`, `loginOtp = '/login/otp'`
  - `final appRouterProvider = Provider<GoRouter>(...)`
  - `extension AuthFlowRoutes on AuthFlow { String get phoneRoute; String get otpRoute; }`
  - `PhonePage({required AuthFlow flow})`, `OnboardingPage()`, `PlaceholderPage({required String title})`, `JDonutsApp()`
  - Test helper `pumpJDonutsApp(WidgetTester, {List<Override> overrides, String? location})`

- [ ] **Step 1: Write the failing test**

`test/helpers/pump_jdonuts_app.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/app.dart';
import 'package:j_donuts_app/core/router/app_router.dart';

/// Pumps the real app (router, theme, l10n) and optionally opens [location].
Future<void> pumpJDonutsApp(
  WidgetTester tester, {
  List<Override> overrides = const [],
  String? location,
}) async {
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, child: const JDonutsApp()),
  );
  if (location != null) {
    final container =
        ProviderScope.containerOf(tester.element(find.byType(JDonutsApp)));
    container.read(appRouterProvider).go(location);
  }
  await tester.pumpAndSettle();
}
```

`test/features/auth/presentation/pages/phone_page_test.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/core/widgets/primary_button.dart';
import 'package:j_donuts_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/pump_jdonuts_app.dart';

void main() {
  const validNumber = '09254135592';
  const invalidMessage =
      'Enter a valid Myanmar mobile number, like 09 123 456 789.';

  PrimaryButton continueButton(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton));

  Future<void> typeNumber(WidgetTester tester, String number) async {
    await tester.enterText(find.byType(TextField), number);
    await tester.pump();
  }

  Future<void> tapOutsideField(WidgetTester tester) async {
    await tester.tap(find.text('Enter your phone number'));
    await tester.pumpAndSettle();
  }

  testWidgets('Continue stays disabled until the number is valid',
      (tester) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    expect(continueButton(tester).onPressed, isNull);

    await typeNumber(tester, '0912');
    expect(continueButton(tester).onPressed, isNull);

    await typeNumber(tester, validNumber);
    expect(continueButton(tester).onPressed, isNotNull);
  });

  testWidgets('shows a toast when an invalid number loses focus',
      (tester) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    await tester.tap(find.byType(TextField));
    await typeNumber(tester, '0912');

    await tapOutsideField(tester);

    expect(find.text(invalidMessage), findsOneWidget);
  });

  testWidgets('shows no toast when a valid number loses focus', (tester) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    await tester.tap(find.byType(TextField));
    await typeNumber(tester, validNumber);

    await tapOutsideField(tester);

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('double tap sends one request, shows spinner, then opens OTP',
      (tester) async {
    final repository = ControllableAuthRepository();
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.registerPhone,
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    await typeNumber(tester, validNumber);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    await tester.tap(find.byType(PrimaryButton), warnIfMissed: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repository.requestCount, 1);

    repository.complete(const Ok(null));
    await tester.pumpAndSettle();
    expect(find.text('Verify your number'), findsOneWidget);
  });

  testWidgets('login with an unregistered number offers to register',
      (tester) async {
    await pumpJDonutsApp(
      tester,
      location: AppRoutes.loginPhone,
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(latency: Duration.zero),
        ),
      ],
    );
    await typeNumber(tester, validNumber);
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    expect(find.text("This number isn't registered yet."), findsOneWidget);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.byType(StepProgressRing), findsOneWidget);
    expect(find.text(validNumber), findsOneWidget);
  });

  testWidgets('progress ring shows on registration and not on login',
      (tester) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    expect(find.byType(StepProgressRing), findsOneWidget);

    await pumpJDonutsApp(tester, location: AppRoutes.loginPhone);
    expect(find.byType(StepProgressRing), findsNothing);
  });

  testWidgets('back returns to onboarding and keeps the typed number',
      (tester) async {
    await pumpJDonutsApp(tester, location: AppRoutes.registerPhone);
    await typeNumber(tester, validNumber);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    expect(find.text(validNumber), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/auth/presentation/pages/phone_page_test.dart`
Expected: FAIL — compile errors, `app.dart` / router / pages not found.

- [ ] **Step 3: Write minimal implementation**

`lib/core/router/app_routes.dart`
```dart
abstract final class AppRoutes {
  static const onboarding = '/';
  static const registerPhone = '/register/phone';
  static const loginPhone = '/login/phone';
  static const registerOtp = '/register/otp';
  static const loginOtp = '/login/otp';
}
```

`lib/features/auth/presentation/auth_routes.dart`
```dart
import '../../../core/router/app_routes.dart';
import '../domain/entities/auth_flow.dart';

extension AuthFlowRoutes on AuthFlow {
  String get phoneRoute => switch (this) {
        AuthFlow.register => AppRoutes.registerPhone,
        AuthFlow.login => AppRoutes.loginPhone,
      };

  String get otpRoute => switch (this) {
        AuthFlow.register => AppRoutes.registerOtp,
        AuthFlow.login => AppRoutes.loginOtp,
      };
}
```

`lib/core/widgets/placeholder_page.dart`
```dart
import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_text_styles.dart';

/// Stand-in for screens not built yet.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(context.l10n.comingSoon, style: AppTextStyles.body),
      ),
    );
  }
}
```

`lib/features/auth/presentation/pages/onboarding_page.dart` (minimal; Task 9 completes it)
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.onboardingPadding),
          child: PrimaryButton(
            label: context.l10n.getStarted,
            onPressed: () => context.push(AppRoutes.registerPhone),
          ),
        ),
      ),
    );
  }
}
```

`lib/features/auth/presentation/pages/phone_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/failures/auth_failure.dart';
import '../auth_routes.dart';
import '../mappers/failure_messages.dart';
import '../providers/phone_step_notifier.dart';
import '../providers/phone_step_state.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/phone_input_field.dart';

class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key, required this.flow});

  final AuthFlow flow;

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  NotifierProvider<PhoneStepNotifier, PhoneStepState> get _provider =>
      phoneStepProvider(widget.flow);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(_provider).input);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_provider.select((s) => s.status), (_, s) => _onStatus(s));
    final state = ref.watch(_provider);
    final notifier = ref.read(_provider.notifier);
    return AuthStepScaffold(
      title: context.l10n.phoneTitle,
      currentStep: widget.flow == AuthFlow.register ? 1 : null,
      onBack: _goBack,
      body: PhoneInputField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: state.isSubmitting,
        onChanged: notifier.onInputChanged,
        onSubmitted: (_) => _onKeyboardDone(state),
      ),
      action: PrimaryButton(
        label: context.l10n.continueLabel,
        isLoading: state.isSubmitting,
        onPressed: state.canSubmit ? notifier.submit : null,
      ),
    );
  }

  void _onFocusChanged() {
    final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
    if (!_focusNode.hasFocus && isCurrentRoute) _warnIfInvalid();
  }

  void _onKeyboardDone(PhoneStepState state) => state.canSubmit
      ? ref.read(_provider.notifier).submit()
      : _warnIfInvalid();

  void _warnIfInvalid() {
    final error = ref.read(_provider).visibleError;
    if (error == null) return;
    AppToast.show(
      context,
      message: error.message(context.l10n),
      type: AppToastType.error,
    );
  }

  void _onStatus(PhoneSubmitStatus status) {
    switch (status) {
      case PhoneSubmitSuccess():
        context.push(widget.flow.otpRoute);
      case PhoneSubmitFailure(:final failure):
        _showAuthFailure(failure);
      case PhoneSubmitIdle() || PhoneSubmitting():
        break;
    }
  }

  void _showAuthFailure(AuthFailure failure) {
    final router = GoRouter.of(context);
    final (actionLabel, target) = switch (failure) {
      AuthFailure.notRegistered => (context.l10n.registerAction, AuthFlow.register),
      AuthFailure.alreadyRegistered => (context.l10n.logIn, AuthFlow.login),
    };
    AppToast.show(
      context,
      message: failure.message(context.l10n),
      type: AppToastType.error,
      actionLabel: actionLabel,
      onAction: () => router.pushReplacement(target.phoneRoute),
    );
  }

  void _goBack() =>
      context.canPop() ? context.pop() : context.go(AppRoutes.onboarding);
}
```

Note: this page is ~120 lines; the "< 80 lines" rule targets layout-only pages. `build` itself is layout + wiring; side-effect handlers stay here because they need `BuildContext` for toasts/navigation.

`lib/core/router/app_router.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/auth_flow.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/phone_page.dart';
import '../l10n/l10n_extension.dart';
import '../widgets/placeholder_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.registerPhone,
        builder: (_, _) => const PhonePage(flow: AuthFlow.register),
      ),
      GoRoute(
        path: AppRoutes.loginPhone,
        builder: (_, _) => const PhonePage(flow: AuthFlow.login),
      ),
      for (final path in [AppRoutes.registerOtp, AppRoutes.loginOtp])
        GoRoute(
          path: path,
          builder: (context, _) =>
              PlaceholderPage(title: context.l10n.verifyNumberTitle),
        ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
```

`lib/app.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/l10n_extension.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

class JDonutsApp extends ConsumerWidget {
  const JDonutsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appName,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
```

`lib/main.dart`
```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() => runApp(const ProviderScope(child: JDonutsApp()));
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/auth/presentation/pages/phone_page_test.dart`
Expected: PASS (7 tests).

- [ ] **Step 5: Full suite + analyze**

Run: `flutter test; flutter analyze`
Expected: all tests pass; `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib test
git commit -m "feat(auth): add phone number step with router and app shell"
```

---

### Task 9: Onboarding screen

**Files:**
- Create: `lib/features/auth/presentation/widgets/onboarding_hero.dart`, `.../login_prompt.dart`, `.../social_login_row.dart`
- Replace: `lib/features/auth/presentation/pages/onboarding_page.dart`
- Test: `test/features/auth/presentation/pages/onboarding_page_test.dart`

**Interfaces:**
- Consumes: Tasks 5–8.
- Produces: `OnboardingHero()` (image placeholders, real donut art added later), `LoginPrompt({required VoidCallback onLogIn})`, `SocialLoginRow({required VoidCallback onGoogle, required VoidCallback onFacebook})` with tooltips `continueWithGoogle` / `continueWithFacebook`.

- [ ] **Step 1: Write the failing test**

`test/features/auth/presentation/pages/onboarding_page_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/widgets/step_progress_ring.dart';

import '../../../../helpers/pump_jdonuts_app.dart';

void main() {
  testWidgets('first launch shows onboarding with brand and actions',
      (tester) async {
    await pumpJDonutsApp(tester);

    expect(find.text("J'Donuts"), findsOneWidget);
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
  });

  testWidgets("Let's get started opens registration step 1", (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.byType(StepProgressRing), findsOneWidget);
  });

  testWidgets('Log In opens the phone step without a progress ring',
      (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.byType(StepProgressRing), findsNothing);
  });

  testWidgets('social sign-in buttons show a coming soon toast',
      (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tap(find.byTooltip('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);

    await tester.tap(find.byTooltip('Continue with Facebook'));
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);
  });

  testWidgets('Terms of Use shows a coming soon toast', (tester) async {
    await pumpJDonutsApp(tester);

    await tester.tapOnText(find.textRange.ofSubstring('Terms of Use'));
    await tester.pumpAndSettle();

    expect(find.text('Coming soon'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/auth/presentation/pages/onboarding_page_test.dart`
Expected: FAIL — brand text, Log In, social buttons and footer not found (minimal page from Task 8).

- [ ] **Step 3: Write minimal implementation**

`lib/features/auth/presentation/widgets/onboarding_hero.dart`
```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

typedef _HeroCircle = ({Alignment alignment, double widthFactor, Color color});

/// Floating donut circles and logo. Circles are colour placeholders until
/// the real donut photos and logo assets are added.
class OnboardingHero extends StatelessWidget {
  const OnboardingHero({super.key});

  static const List<_HeroCircle> _circles = [
    (alignment: Alignment(-1.4, -1.1), widthFactor: 0.45, color: AppColors.heroCyan),
    (alignment: Alignment(0, -0.85), widthFactor: 0.5, color: AppColors.heroPeach),
    (alignment: Alignment(1.4, -1.1), widthFactor: 0.32, color: AppColors.heroPink),
    (alignment: Alignment(-1.45, -0.1), widthFactor: 0.4, color: AppColors.heroLavender),
    (alignment: Alignment(1.45, -0.15), widthFactor: 0.3, color: AppColors.heroCyan),
  ];
  static const _logoAlignment = Alignment(0, 0.75);
  static const _logoWidthFactor = 0.55;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return ClipRect(
          child: Stack(
            children: [
              for (final circle in _circles)
                Align(
                  alignment: circle.alignment,
                  child: _Circle(diameter: width * circle.widthFactor, color: circle.color),
                ),
              Align(
                alignment: _logoAlignment,
                child: _Circle(
                  diameter: width * _logoWidthFactor,
                  color: AppColors.heroPink,
                  child: Text(context.l10n.appName, style: AppTextStyles.brand),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.diameter, required this.color, this.child});

  final double diameter;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: child == null ? null : FittedBox(child: child),
    );
  }
}
```

`lib/features/auth/presentation/widgets/login_prompt.dart`
```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key, required this.onLogIn});

  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(l10n.alreadyHaveAccount, style: AppTextStyles.body),
        TextButton(
          onPressed: onLogIn,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
          ),
          child: Text(l10n.logIn, style: AppTextStyles.link),
        ),
      ],
    );
  }
}
```

`lib/features/auth/presentation/widgets/social_login_row.dart`
```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';

/// Google and Facebook buttons. Icons are placeholders until brand assets
/// are added.
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({
    super.key,
    required this.onGoogle,
    required this.onFacebook,
  });

  final VoidCallback onGoogle;
  final VoidCallback onFacebook;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          tooltip: context.l10n.continueWithGoogle,
          icon: Icons.g_mobiledata_rounded,
          iconColor: AppColors.textPrimary,
          onTap: onGoogle,
        ),
        const SizedBox(width: AppDimens.spaceXl),
        _SocialButton(
          tooltip: context.l10n.continueWithFacebook,
          icon: Icons.facebook,
          iconColor: AppColors.facebookBlue,
          onTap: onFacebook,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.tooltip,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        elevation: AppDimens.spaceXs,
        shadowColor: AppColors.shadow,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: AppDimens.socialButtonSize,
            child: Icon(icon, color: iconColor, size: AppDimens.iconLg),
          ),
        ),
      ),
    );
  }
}
```

`lib/features/auth/presentation/pages/onboarding_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/legal_footer.dart';
import '../widgets/login_prompt.dart';
import '../widgets/onboarding_hero.dart';
import '../widgets/social_login_row.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    void comingSoon() =>
        AppToast.show(context, message: context.l10n.comingSoon);

    return Scaffold(
      body: GradientBackground(
        colors: AppColors.onboardingGradient,
        child: SafeArea(
          child: Column(
            children: [
              const Expanded(child: OnboardingHero()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.onboardingPadding,
                ),
                child: Column(
                  children: [
                    PrimaryButton(
                      label: context.l10n.getStarted,
                      onPressed: () => context.push(AppRoutes.registerPhone),
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    LoginPrompt(
                      onLogIn: () => context.push(AppRoutes.loginPhone),
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    SocialLoginRow(onGoogle: comingSoon, onFacebook: comingSoon),
                    const SizedBox(height: AppDimens.spaceLg),
                    LegalFooter(onTermsTap: comingSoon, onPrivacyTap: comingSoon),
                    const SizedBox(height: AppDimens.spaceMd),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/auth/presentation/pages`
Expected: PASS (12 tests: 7 phone + 5 onboarding). Phone page "back keeps number" test now uses the full onboarding page.

- [ ] **Step 5: Full suite + analyze + format**

Run: `dart format lib test; flutter analyze; flutter test`
Expected: `No issues found!`; all tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib test
git commit -m "feat(auth): build onboarding screen with placeholder hero"
```

---

### Task 10: Device check

- [ ] **Step 1:** `flutter run` on an Android emulator. Verify by eye against the screenshots: gradient, cyan button, pink links, ring at 25%, toast style, spinner morph, text scale 1.3 (Settings → font size) has no overflow.
- [ ] **Step 2:** Fix any fidelity issue found, re-run `flutter analyze; flutter test`, commit `fix(auth): ...`.
