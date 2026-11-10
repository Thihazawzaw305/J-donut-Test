import '../../domain/repositories/session_repository.dart';
import '../datasources/local/session_storage.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._storage);

  final SessionStorage _storage;

  @override
  Future<void> clear() => _storage.delete();

  @override
  Future<String?> readActivePhoneE164() => _storage.read();

  @override
  Future<void> saveActivePhone(String e164) => _storage.write(e164);
}
