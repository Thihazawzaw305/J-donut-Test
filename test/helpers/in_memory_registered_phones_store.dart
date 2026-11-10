import 'package:j_donuts_app/features/auth/data/datasources/local/registered_phones_store.dart';

class InMemoryRegisteredPhonesStore implements RegisteredPhonesStore {
  final Set<String> _numbers = {};

  @override
  Future<void> add(String e164) async {
    _numbers.add(e164);
  }

  @override
  Future<Set<String>> readAll() async => Set.unmodifiable(_numbers);
}
