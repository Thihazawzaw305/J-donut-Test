/// Low-level key-value persistence for the active session phone.
abstract interface class SessionStorage {
  Future<String?> read();

  Future<void> write(String value);

  Future<void> delete();
}
