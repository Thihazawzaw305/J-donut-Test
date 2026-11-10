import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityOfflineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  var offline = await _isOffline(connectivity);
  yield offline;
  await for (final results in connectivity.onConnectivityChanged) {
    offline = results.every((r) => r == ConnectivityResult.none);
    yield offline;
  }
});

Future<bool> _isOffline(Connectivity connectivity) async {
  final results = await connectivity.checkConnectivity();
  return results.isEmpty ||
      results.every((r) => r == ConnectivityResult.none);
}
