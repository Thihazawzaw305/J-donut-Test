/// Persists the logged-in member's phone (E.164) across app restarts.
abstract interface class SessionRepository {
  Future<String?> readActivePhoneE164();

  Future<void> saveActivePhone(String e164);

  Future<void> clear();
}
