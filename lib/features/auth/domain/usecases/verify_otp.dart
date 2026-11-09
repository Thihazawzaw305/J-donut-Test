import '../../../../core/errors/result.dart';
import '../entities/auth_flow.dart';
import '../entities/otp_code.dart';
import '../entities/phone_number.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<void, AuthFailure>> call(
    PhoneNumber phone,
    OtpCode code, {
    required AuthFlow flow,
  }) => _repository.verifyOtp(phone, code, flow: flow);
}
