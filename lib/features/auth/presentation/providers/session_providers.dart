import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/secure_session_storage.dart';
import '../../data/datasources/local/session_storage.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../domain/repositories/session_repository.dart';

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SecureSessionStorage(),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepositoryImpl(ref.watch(sessionStorageProvider)),
);

/// Notifies [GoRouter] when login state changes.
final sessionRefreshProvider = Provider<SessionRefresh>((ref) {
  final refresh = SessionRefresh();
  ref.onDispose(refresh.dispose);
  return refresh;
});

final class SessionRefresh extends ChangeNotifier {
  void bump() => notifyListeners();
}
