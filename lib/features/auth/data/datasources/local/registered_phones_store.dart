import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists fake-auth registered E.164 numbers across app restarts.
abstract class RegisteredPhonesStore {
  Future<Set<String>> readAll();
  Future<void> add(String e164);
}

class SecureRegisteredPhonesStore implements RegisteredPhonesStore {
  SecureRegisteredPhonesStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'registered_phones_v1';

  final FlutterSecureStorage _storage;

  @override
  Future<Set<String>> readAll() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! List) return {};
    return decoded.whereType<String>().toSet();
  }

  @override
  Future<void> add(String e164) async {
    final existing = await readAll();
    if (existing.contains(e164)) return;
    final next = [...existing, e164];
    await _storage.write(key: _key, value: jsonEncode(next));
  }
}
