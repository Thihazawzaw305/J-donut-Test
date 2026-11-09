import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fake_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/complete_registration.dart';
import '../../domain/usecases/request_otp.dart';
import '../../domain/usecases/resend_otp.dart';
import '../../domain/usecases/save_profile_name.dart';
import '../../domain/usecases/verify_otp.dart';

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(),
);

final requestOtpProvider = Provider<RequestOtp>(
  (ref) => RequestOtp(ref.watch(authRepositoryProvider)),
);

final verifyOtpProvider = Provider<VerifyOtp>(
  (ref) => VerifyOtp(ref.watch(authRepositoryProvider)),
);

final resendOtpProvider = Provider<ResendOtp>(
  (ref) => ResendOtp(ref.watch(authRepositoryProvider)),
);

final saveProfileNameProvider = Provider<SaveProfileName>(
  (ref) => SaveProfileName(ref.watch(authRepositoryProvider)),
);

final completeRegistrationProvider = Provider<CompleteRegistration>(
  (ref) => CompleteRegistration(ref.watch(authRepositoryProvider)),
);
