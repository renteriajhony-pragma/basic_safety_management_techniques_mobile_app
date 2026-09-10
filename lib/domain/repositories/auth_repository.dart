import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> createSession(
    String subject, {
    String? givenName,
    String? familyName,
  });

  Future<AuthSession?> getSession();

  Future<void> clearSession();
}
