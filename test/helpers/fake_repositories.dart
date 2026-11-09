import 'dart:async';

import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/repositories/auth_repository.dart';

/// Holds every request open until [complete] is called.
class ControllableAuthRepository implements AuthRepository {
  final _completer = Completer<Result<void, AuthFailure>>();
  int requestCount = 0;
  AuthFlow? lastFlow;

  @override
  Future<Result<void, AuthFailure>> requestOtp(
    PhoneNumber phone, {
    required AuthFlow flow,
  }) {
    requestCount++;
    lastFlow = flow;
    return _completer.future;
  }

  void complete(Result<void, AuthFailure> result) =>
      _completer.complete(result);
}
