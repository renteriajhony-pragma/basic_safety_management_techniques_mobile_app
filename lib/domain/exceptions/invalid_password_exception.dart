class InvalidPasswordException implements Exception {
  const InvalidPasswordException(this.message);

  final String message;

  @override
  String toString() => 'InvalidPasswordException: $message';
}
