import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class RefreshSessionUseCase {
  const RefreshSessionUseCase(this._repository);

  final AuthRepository _repository;

  /// Issues a new token for the subject of [currentSession], carrying the
  /// same claims, and persists it in place of the current one.
  Future<AuthSession> call(AuthSession currentSession) {
    return _repository.createSession(
      currentSession.subject,
      givenName: currentSession.givenName,
      familyName: currentSession.familyName,
    );
  }
}
