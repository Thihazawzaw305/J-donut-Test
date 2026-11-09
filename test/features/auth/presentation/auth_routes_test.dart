import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/router/app_routes.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/presentation/auth_routes.dart';

void main() {
  test('register flow exposes name and date-of-birth routes', () {
    expect(AuthFlow.register.nameRoute, AppRoutes.registerName);
    expect(AuthFlow.register.dobRoute, AppRoutes.registerDob);
  });

  test('login flow does not expose name or date-of-birth routes', () {
    expect(() => AuthFlow.login.nameRoute, throwsUnsupportedError);
    expect(() => AuthFlow.login.dobRoute, throwsUnsupportedError);
  });
}
