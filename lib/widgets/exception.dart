class ExceptionClass implements Exception {
  final String message;

  ExceptionClass(this.message);

  @override
  String toString() {
    return message;
  }
}
