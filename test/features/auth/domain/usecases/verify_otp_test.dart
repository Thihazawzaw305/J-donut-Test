import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/otp_code.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/usecases/verify_otp.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  test('forwards phone, code and flow to the repository', () async {
    final repository = ControllableAuthRepository();
    final verifyOtp = VerifyOtp(repository);

    final pending = verifyOtp(
      const PhoneNumber('9254135592'),
      const OtpCode('000000'),
      flow: AuthFlow.register,
    );
    repository.completeVerify(const Err(AuthFailure.wrongOtp));

    expect((await pending).errorOrNull, AuthFailure.wrongOtp);
    expect(repository.verifyCount, 1);
    expect(repository.lastCode, const OtpCode('000000'));
    expect(repository.lastVerifyFlow, AuthFlow.register);
  });
}
