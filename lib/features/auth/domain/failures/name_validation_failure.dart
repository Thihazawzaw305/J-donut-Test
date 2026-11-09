import '../../../../core/errors/failure.dart';

enum NameValidationFailure implements Failure {
  empty,
  tooLong,
  containsDigit,
  invalidCharacters,
}
