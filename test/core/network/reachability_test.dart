import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/network/reachability.dart';

void main() {
  test('hasReachableInternet returns a boolean without throwing', () async {
    final result = await hasReachableInternet();
    expect(result, isA<bool>());
  });
}
