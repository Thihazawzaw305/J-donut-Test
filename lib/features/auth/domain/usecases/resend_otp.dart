import '../../../../core/errors/result.dart';
import '../entities/phone_number.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

class ResendOtp {
  const ResendOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<void, AuthFailure>> call(PhoneNumber phone) =>
      _repository.resendOtp(phone);
}
