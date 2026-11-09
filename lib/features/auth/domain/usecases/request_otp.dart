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
  }) => _repository.requestOtp(phone, flow: flow);
}
