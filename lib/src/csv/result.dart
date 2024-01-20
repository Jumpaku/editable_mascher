sealed class Result<S, E extends Exception> {
  const Result();

  S? getValue() => switch (this) {
        Failure() => null,
        Success(value: var value) => value
      };

  E? getException() => switch (this) {
        Failure(exception: var exception) => exception,
        Success() => null
      };
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);

  final S value;

  @override
  String toString() => "Success(value=$value)";
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.exception);

  final E exception;

  @override
  String toString() => "Failure(exception=$exception)";
}
