import '../../../../core/errors/result.dart';
import '../entities/phone_number.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

class SaveProfileName {
  const SaveProfileName(this._repository);

  final AuthRepository _repository;

  Future<Result<void, AuthFailure>> call(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
  }) => _repository.saveProfileName(
    phone,
    firstName: firstName,
    lastName: lastName,
  );
}
