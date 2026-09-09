class ExpiredSessionException implements Exception {
  const ExpiredSessionException([
    this.message = 'No puedes refrescar una sesión expirada. Vuelve a iniciar sesión.',
  ]);

  final String message;

  @override
  String toString() => 'ExpiredSessionException: $message';
}
