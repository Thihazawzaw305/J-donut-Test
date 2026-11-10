import 'dart:async';

import 'package:j_donuts_app/core/errors/result.dart';
import 'package:j_donuts_app/features/auth/domain/entities/auth_flow.dart';
import 'package:j_donuts_app/features/auth/domain/entities/date_of_birth.dart';
import 'package:j_donuts_app/features/auth/domain/entities/otp_code.dart';
import 'package:j_donuts_app/features/auth/domain/entities/phone_number.dart';
import 'package:j_donuts_app/features/auth/domain/failures/auth_failure.dart';
import 'package:j_donuts_app/features/auth/domain/repositories/auth_repository.dart';

/// Holds every request open until [complete] is called.
class ControllableAuthRepository implements AuthRepository {
  final _completer = Completer<Result<void, AuthFailure>>();
  final _verifyCompleters = <Completer<Result<void, AuthFailure>>>[];
  final _saveNameCompleter = Completer<Result<void, AuthFailure>>();
  final _completeRegistrationCompleter = Completer<Result<void, AuthFailure>>();
  int requestCount = 0;
  int verifyCount = 0;
  int resendCount = 0;
  int saveProfileNameCount = 0;
  int completeRegistrationCount = 0;
  AuthFlow? lastFlow;
  AuthFlow? lastVerifyFlow;
  OtpCode? lastCode;

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

  @override
  Future<Result<void, AuthFailure>> verifyOtp(
    PhoneNumber phone,
    OtpCode code, {
    required AuthFlow flow,
  }) {
    verifyCount++;
    lastCode = code;
    lastVerifyFlow = flow;
    final completer = Completer<Result<void, AuthFailure>>();
    _verifyCompleters.add(completer);
    return completer.future;
  }

  void completeVerify(Result<void, AuthFailure> result) =>
      _verifyCompleters.firstWhere((c) => !c.isCompleted).complete(result);

  @override
  Future<Result<void, AuthFailure>> resendOtp(PhoneNumber phone) async {
    resendCount++;
    return const Ok(null);
  }

  @override
  Future<Result<void, AuthFailure>> saveProfileName(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
  }) {
    saveProfileNameCount++;
    return _saveNameCompleter.future;
  }

  void completeSaveProfileName(Result<void, AuthFailure> result) =>
      _saveNameCompleter.complete(result);

  @override
  Future<Result<void, AuthFailure>> completeRegistration(
    PhoneNumber phone, {
    required String firstName,
    String? lastName,
    required DateOfBirth dateOfBirth,
  }) {
    completeRegistrationCount++;
    return _completeRegistrationCompleter.future;
  }

  void finishCompleteRegistration(Result<void, AuthFailure> result) =>
      _completeRegistrationCompleter.complete(result);
}
