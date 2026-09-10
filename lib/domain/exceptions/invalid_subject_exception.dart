class InvalidSubjectException implements Exception {
  const InvalidSubjectException(this.message);

  final String message;

  @override
  String toString() => 'InvalidSubjectException: $message';
}
