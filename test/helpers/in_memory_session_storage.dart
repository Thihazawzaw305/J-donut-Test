import 'package:j_donuts_app/features/auth/data/datasources/local/session_storage.dart';

class InMemorySessionStorage implements SessionStorage {
  String? _value;

  @override
  Future<void> delete() async => _value = null;

  @override
  Future<String?> read() async => _value;

  @override
  Future<void> write(String value) async => _value = value;
}
