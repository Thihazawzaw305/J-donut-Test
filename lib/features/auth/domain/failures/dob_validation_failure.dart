import '../../../../core/errors/failure.dart';

enum DobValidationFailure implements Failure {
  incomplete,
  invalidDate,
  inFuture,
  tooYoung,
}
