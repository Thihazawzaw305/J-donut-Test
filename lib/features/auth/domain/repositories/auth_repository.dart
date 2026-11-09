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
