import '../../../../core/errors/result.dart';
import '../../domain/entities/auth_flow.dart';
import '../../domain/entities/date_of_birth.dart';
import '../../domain/entities/otp_code.dart';
import '../../domain/entities/phone_number.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/policies/otp_policy.dart';
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
  final Map<String, int> _otpAttempts = <String, int>{};

  @override
  Future<Result<void, AuthFailure>> requestOtp(
    PhoneNumber phone, {
    required AuthFlow flow,
  }) async {
    await Future<void>.delayed(latency);
    final isRegistered = _registeredNumbers.contains(phone.e164);
    return switch (flow) {
      AuthFlow.login when !isRegistered => const Err(AuthFailure.notRegistered),
      AuthFlow.register when isRegistered => const Err(
        AuthFailure.alreadyRegistered,
      ),
      _ => const Ok(null),
    };
  }

  @override
  Future<Result<void, AuthFailure>> verifyOtp(
    PhoneNumber phone,
    OtpCode code, {
    required AuthFlow flow,
  }) async {
    await Future<void>.delayed(latency);
    final isRegistered = _registeredNumbers.contains(phone.e164);
    if (flow == AuthFlow.login && !isRegistered) {
      return const Err(AuthFailure.notRegistered);
    }
    if (code.digits == OtpPolicy.correctCode) {
      return const Ok(null);
    }

    final attempts = (_otpAttempts[phone.e164] ?? 0) + 1;
    _otpAttempts[phone.e164] = attempts;
    if (attempts >= OtpPolicy.maxAttempts) {
      return const Err(AuthFailure.otpLocked);
    }
    return const Err(AuthFailure.wrongOtp);
  }

  @override
  Future<Result<void, AuthFailure>> resendOtp(PhoneNumber phone) async {
    await Future<void>.delayed(latency);
    _otpAttempts.remove(phone.e164);
    return const Ok(null);
  }

  @override
  Future<Result<void, AuthFailure>> saveProfileName(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
  }) async {
    await Future<void>.delayed(latency);
    return const Ok(null);
  }

  @override
  Future<Result<void, AuthFailure>> completeRegistration(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
    required DateOfBirth dateOfBirth,
  }) async {
    await Future<void>.delayed(latency);
    _registeredNumbers.add(phone.e164);
    return const Ok(null);
  }
}
