import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'session_providers.dart';

class SessionNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return ref.watch(sessionRepositoryProvider).readActivePhoneE164();
  }

  Future<void> saveActivePhone(String e164) async {
    await ref.read(sessionRepositoryProvider).saveActivePhone(e164);
    state = AsyncData(e164);
    ref.read(sessionRefreshProvider).bump();
  }

  Future<void> logout() async {
    await ref.read(sessionRepositoryProvider).clear();
    state = const AsyncData(null);
    ref.read(sessionRefreshProvider).bump();
  }
}

final sessionProvider = AsyncNotifierProvider<SessionNotifier, String?>(
  SessionNotifier.new,
);
