import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class GetSessionUseCase {
  const GetSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession?> call() => _repository.getSession();
}
