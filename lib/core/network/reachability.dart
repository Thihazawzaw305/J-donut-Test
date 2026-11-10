import 'dart:io';

/// Best-effort internet check after [connectivity_plus] reports a link.
Future<bool> hasReachableInternet() async {
  final client = HttpClient();
  try {
    client.connectionTimeout = const Duration(seconds: 3);
    final request = await client.headUrl(
      Uri.parse('https://clients3.google.com/generate_204'),
    );
    final response = await request.close();
    final ok = response.statusCode >= 200 && response.statusCode < 400;
    await response.drain<void>();
    return ok;
  } on Object {
    return false;
  } finally {
    client.close(force: true);
  }
}
