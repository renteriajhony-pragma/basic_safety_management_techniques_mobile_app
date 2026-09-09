import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> createSession(String subject);

  Future<AuthSession?> getSession();
}
