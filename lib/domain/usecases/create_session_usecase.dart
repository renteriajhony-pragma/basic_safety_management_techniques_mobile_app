import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class CreateSessionUseCase {
  const CreateSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call(String subject) => _repository.createSession(subject);
}
