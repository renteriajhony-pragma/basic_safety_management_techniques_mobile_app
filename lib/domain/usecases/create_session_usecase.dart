import '../entities/auth_session.dart';
import '../exceptions/invalid_subject_exception.dart';
import '../repositories/auth_repository.dart';
import '../validators/subject_validator.dart';

class CreateSessionUseCase {
  const CreateSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call(String subject) {
    if (!SubjectValidator.isValid(subject)) {
      throw const InvalidSubjectException(
        'El usuario debe tener entre ${SubjectValidator.minLength} y '
        '${SubjectValidator.maxLength} caracteres (letras, números, "-" o "_")',
      );
    }
    return _repository.createSession(subject);
  }
}
