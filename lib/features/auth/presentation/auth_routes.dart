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
}
