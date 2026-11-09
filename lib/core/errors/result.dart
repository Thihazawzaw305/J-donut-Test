import 'failure.dart';

sealed class Result<T, E extends Failure> {
  const Result();

  bool get isOk => this is Ok<T, E>;

  T? get valueOrNull => switch (this) {
        Ok<T, E>(:final value) => value,
        Err<T, E>() => null,
      };

  E? get errorOrNull => switch (this) {
        Ok<T, E>() => null,
        Err<T, E>(:final error) => error,
      };
}

final class Ok<T, E extends Failure> extends Result<T, E> {
  const Ok(this.value);

  final T value;
}

final class Err<T, E extends Failure> extends Result<T, E> {
  const Err(this.error);

  final E error;
}
