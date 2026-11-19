/// The outcome of a repository call: [Ok] with a value or [Error] with an
/// exception. Read it with [fold] (or a `switch`); both handle every case.
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>._;

  const factory Result.error(Exception error) = Error<T>._;

  /// Returns [onOk] of the value or [onError] of the error, whichever this is.
  R fold<R>({
    required R Function(T value) onOk,
    required R Function(Exception error) onError,
  }) => switch (this) {
    Ok(:final value) => onOk(value),
    Error(:final error) => onError(error),
  };
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error._(this.error);

  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
