import 'package:security_app/domain/entities/auth_session.dart';
import 'package:security_app/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  AuthSession? sessionToReturn;
  String? lastCreatedSubject;

  @override
  Future<AuthSession> createSession(String subject) async {
    lastCreatedSubject = subject;
    final session = AuthSession(
      token: 'fake-token',
      subject: subject,
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
    sessionToReturn = session;
    return session;
  }

  @override
  Future<AuthSession?> getSession() async => sessionToReturn;

  @override
  Future<void> clearSession() async {
    sessionToReturn = null;
  }
}
