import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/reachability.dart';

final connectivityOfflineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  var offline = await _isOffline(connectivity);
  yield offline;
  await for (final results in connectivity.onConnectivityChanged) {
    offline = await _evaluateOffline(connectivity, results);
    yield offline;
  }
});

Future<bool> _isOffline(Connectivity connectivity) async {
  final results = await connectivity.checkConnectivity();
  return _evaluateOffline(connectivity, results);
}

Future<bool> _evaluateOffline(
  Connectivity connectivity,
  List<ConnectivityResult> results,
) async {
  final noLink =
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);
  if (noLink) return true;
  return !(await hasReachableInternet());
}
