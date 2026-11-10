import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/auth_draft_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/session_notifier.dart';
import 'package:j_donuts_app/features/auth/presentation/providers/session_providers.dart';

import '../../../../helpers/in_memory_session_storage.dart';

void main() {
  test('logout clears the session and the typed auth draft', () async {
    final storage = InMemorySessionStorage();
    final container = ProviderContainer(
      overrides: [sessionStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    final draft = container.read(authDraftProvider.notifier);
    draft.updatePhoneInput('09254135592');
    draft.updateOtpInput('123456');
    draft.updateFirstName('Alice');
    await container
        .read(sessionProvider.notifier)
        .saveActivePhone('+959254135592');

    await container.read(sessionProvider.notifier).logout();

    expect(await storage.read(), isNull);
    expect(container.read(sessionProvider).value, isNull);
    final cleared = container.read(authDraftProvider);
    expect(cleared.phoneInput, isEmpty);
    expect(cleared.otpInput, isEmpty);
    expect(cleared.firstName, isEmpty);
  });
}
