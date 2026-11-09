import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/date_of_birth.dart';

/// Input kept across auth steps so Back never loses what was typed.
class AuthDraft {
  const AuthDraft({
    this.phoneInput = '',
    this.otpInput = '',
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth,
  });

  final String phoneInput;
  final String otpInput;
  final String firstName;
  final String lastName;
  final DateOfBirth? dateOfBirth;

  AuthDraft copyWith({
    String? phoneInput,
    String? otpInput,
    String? firstName,
    String? lastName,
    DateOfBirth? dateOfBirth,
  }) => AuthDraft(
    phoneInput: phoneInput ?? this.phoneInput,
    otpInput: otpInput ?? this.otpInput,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
  );
}

class AuthDraftNotifier extends Notifier<AuthDraft> {
  @override
  AuthDraft build() => const AuthDraft();

  void updatePhoneInput(String value) =>
      state = state.copyWith(phoneInput: value);

  void updateOtpInput(String value) => state = state.copyWith(otpInput: value);

  void updateFirstName(String value) =>
      state = state.copyWith(firstName: value);

  void updateLastName(String value) => state = state.copyWith(lastName: value);

  void updateDateOfBirth(DateOfBirth? value) =>
      state = AuthDraft(
        phoneInput: state.phoneInput,
        otpInput: state.otpInput,
        firstName: state.firstName,
        lastName: state.lastName,
        dateOfBirth: value,
      );
}

final authDraftProvider = NotifierProvider<AuthDraftNotifier, AuthDraft>(
  AuthDraftNotifier.new,
);
