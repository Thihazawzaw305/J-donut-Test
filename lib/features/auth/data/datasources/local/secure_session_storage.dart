import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'session_storage.dart';

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _keyActivePhone = 'active_phone_e164';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read() => _storage.read(key: _keyActivePhone);

  @override
  Future<void> write(String value) =>
      _storage.write(key: _keyActivePhone, value: value);

  @override
  Future<void> delete() => _storage.delete(key: _keyActivePhone);
}
