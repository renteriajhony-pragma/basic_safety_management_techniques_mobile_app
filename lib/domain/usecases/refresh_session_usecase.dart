import '../entities/auth_session.dart';
import '../exceptions/expired_session_exception.dart';
import '../repositories/auth_repository.dart';

class RefreshSessionUseCase {
  const RefreshSessionUseCase(this._repository);

  final AuthRepository _repository;

  /// Issues a new token for the subject of [currentSession], carrying the
  /// same claims, and persists it in place of the current one.
  ///
  /// Throws [ExpiredSessionException] if [currentSession] has already
  /// expired: an expired session cannot be extended, it can only be
  /// replaced by logging in again.
  Future<AuthSession> call(AuthSession currentSession) {
    if (!currentSession.isValid) {
      throw const ExpiredSessionException();
    }
    return _repository.createSession(
      currentSession.subject,
      givenName: currentSession.givenName,
      familyName: currentSession.familyName,
    );
  }
}
