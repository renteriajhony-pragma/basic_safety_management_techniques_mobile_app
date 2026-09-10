import '../entities/user_profile.dart';
import '../exceptions/invalid_password_exception.dart';
import '../exceptions/invalid_subject_exception.dart';
import '../repositories/user_repository.dart';
import '../validators/password_validator.dart';
import '../validators/subject_validator.dart';

class RegisterUserUseCase {
  const RegisterUserUseCase(this._repository);

  final UserRepository _repository;

  Future<void> call(UserProfile profile, String password) {
    if (!SubjectValidator.isValid(profile.usuario)) {
      throw const InvalidSubjectException(
        'El usuario debe tener entre ${SubjectValidator.minLength} y '
        '${SubjectValidator.maxLength} caracteres (letras, números, "-" o "_")',
      );
    }
    if (!PasswordValidator.isValid(password)) {
      throw const InvalidPasswordException(
        'La contraseña debe tener entre ${PasswordValidator.minLength} y '
        '${PasswordValidator.maxLength} caracteres',
      );
    }
    return _repository.register(profile, password);
  }
}
