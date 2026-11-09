import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/usecases/request_otp.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  test('forwards the phone and flow to the repository and returns its result',
      () async {
    final repository = ControllableAuthRepository();
    final requestOtp = RequestOtp(repository);

    final pending =
        requestOtp(const PhoneNumber('9254135592'), flow: AuthFlow.login);
    repository.complete(const Err(AuthFailure.notRegistered));

    expect((await pending).errorOrNull, AuthFailure.notRegistered);
    expect(repository.requestCount, 1);
    expect(repository.lastFlow, AuthFlow.login);
  });
}
