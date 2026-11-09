import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Input kept across auth steps so Back never loses what was typed.
class AuthDraft {
  const AuthDraft({this.phoneInput = ''});

  final String phoneInput;

  AuthDraft copyWith({String? phoneInput}) =>
      AuthDraft(phoneInput: phoneInput ?? this.phoneInput);
}

class AuthDraftNotifier extends Notifier<AuthDraft> {
  @override
  AuthDraft build() => const AuthDraft();

  void updatePhoneInput(String value) =>
      state = state.copyWith(phoneInput: value);
}

final authDraftProvider = NotifierProvider<AuthDraftNotifier, AuthDraft>(
  AuthDraftNotifier.new,
);
