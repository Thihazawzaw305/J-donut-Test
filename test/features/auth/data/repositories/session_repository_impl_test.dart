import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/data/repositories/session_repository_impl.dart';

import '../../../../helpers/in_memory_session_storage.dart';

void main() {
  test('save and read active phone e164', () async {
    final repo = SessionRepositoryImpl(InMemorySessionStorage());
    expect(await repo.readActivePhoneE164(), isNull);
    await repo.saveActivePhone('+959254135592');
    expect(await repo.readActivePhoneE164(), '+959254135592');
  });

  test('clear removes saved session', () async {
    final repo = SessionRepositoryImpl(InMemorySessionStorage());
    await repo.saveActivePhone('+959254135592');
    await repo.clear();
    expect(await repo.readActivePhoneE164(), isNull);
  });
}
