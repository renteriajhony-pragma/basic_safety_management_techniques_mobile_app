class AuthSession {
  const AuthSession({
    required this.token,
    required this.subject,
    required this.expiresAt,
    this.givenName,
    this.familyName,
  });

  final String token;
  final String subject;
  final DateTime expiresAt;
  final String? givenName;
  final String? familyName;

  bool get isValid => expiresAt.isAfter(DateTime.now().toUtc());
}
