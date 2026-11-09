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
