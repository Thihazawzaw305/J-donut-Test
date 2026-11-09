import '../../../../core/errors/result.dart';
import '../entities/date_of_birth.dart';
import '../entities/phone_number.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

class CompleteRegistration {
  const CompleteRegistration(this._repository);

  final AuthRepository _repository;

  Future<Result<void, AuthFailure>> call(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
    required DateOfBirth dateOfBirth,
  }) => _repository.completeRegistration(
    phone,
    firstName: firstName,
    lastName: lastName,
    dateOfBirth: dateOfBirth,
  );
}
