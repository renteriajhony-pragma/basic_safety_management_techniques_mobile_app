class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException([
    this.message = 'Usuario o contraseña incorrectos',
  ]);

  final String message;

  @override
  String toString() => 'InvalidCredentialsException: $message';
}
