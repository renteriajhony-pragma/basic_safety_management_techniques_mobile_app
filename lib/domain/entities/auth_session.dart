class AuthSession {
  const AuthSession({
    required this.token,
    required this.subject,
    required this.expiresAt,
  });

  final String token;
  final String subject;
  final DateTime expiresAt;

  bool get isValid => expiresAt.isAfter(DateTime.now().toUtc());
}
