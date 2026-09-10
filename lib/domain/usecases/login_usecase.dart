import '../entities/auth_session.dart';
import '../exceptions/invalid_credentials_exception.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class LoginUseCase {
  const LoginUseCase({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository;

  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  Future<AuthSession> call({
    required String usuario,
    required String password,
  }) async {
    final isValid = await _userRepository.verifyCredentials(usuario, password);
    if (!isValid) {
      throw const InvalidCredentialsException();
    }

    final profile = await _userRepository.getProfile();
    return _authRepository.createSession(
      usuario,
      givenName: profile?.nombre,
      familyName: profile?.apellido,
    );
  }
}
