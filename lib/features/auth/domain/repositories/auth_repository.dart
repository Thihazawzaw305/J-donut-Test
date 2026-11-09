import '../../../../core/errors/result.dart';
import '../entities/auth_flow.dart';
import '../entities/date_of_birth.dart';
import '../entities/otp_code.dart';
import '../entities/phone_number.dart';
import '../failures/auth_failure.dart';

abstract interface class AuthRepository {
  Future<Result<void, AuthFailure>> requestOtp(
    PhoneNumber phone, {
    required AuthFlow flow,
  });

  Future<Result<void, AuthFailure>> verifyOtp(
    PhoneNumber phone,
    OtpCode code, {
    required AuthFlow flow,
  });

  Future<Result<void, AuthFailure>> resendOtp(PhoneNumber phone);

  Future<Result<void, AuthFailure>> saveProfileName(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
  });

  Future<Result<void, AuthFailure>> completeRegistration(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
    required DateOfBirth dateOfBirth,
  });
}
