import '../../../core/router/app_routes.dart';
import '../domain/entities/auth_flow.dart';

extension AuthFlowRoutes on AuthFlow {
  String get phoneRoute => switch (this) {
    AuthFlow.register => AppRoutes.registerPhone,
    AuthFlow.login => AppRoutes.loginPhone,
  };

  String get otpRoute => switch (this) {
    AuthFlow.register => AppRoutes.registerOtp,
    AuthFlow.login => AppRoutes.loginOtp,
  };

  /// Name and DOB exist only on the registration stack.
  String get nameRoute => switch (this) {
    AuthFlow.register => AppRoutes.registerName,
    AuthFlow.login => throw UnsupportedError(
      'Name is a register-only step',
    ),
  };

  String get dobRoute => switch (this) {
    AuthFlow.register => AppRoutes.registerDob,
    AuthFlow.login => throw UnsupportedError(
      'Date of birth is a register-only step',
    ),
  };
}
