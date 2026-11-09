import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/errors/failure.dart';
import 'package:j_donuts_app/core/errors/result.dart';

enum _TestFailure implements Failure { boom }

void main() {
  group('Result', () {
    test('Ok exposes its value and no error', () {
      const Result<int, _TestFailure> result = Ok(42);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, 42);
      expect(result.errorOrNull, isNull);
    });

    test('Err exposes its error and no value', () {
      const Result<int, _TestFailure> result = Err(_TestFailure.boom);

      expect(result.isOk, isFalse);
      expect(result.valueOrNull, isNull);
      expect(result.errorOrNull, _TestFailure.boom);
    });
  });
}
