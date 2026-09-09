import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/entities/document_type.dart';
import 'package:security_app/domain/entities/sex.dart';
import 'package:security_app/domain/entities/user_profile.dart';
import 'package:security_app/domain/exceptions/invalid_credentials_exception.dart';
import 'package:security_app/domain/usecases/login_usecase.dart';

import '../../helpers/fake_auth_repository.dart';
import '../../helpers/fake_user_repository.dart';

void main() {
  late FakeUserRepository userRepository;
  late FakeAuthRepository authRepository;
  late LoginUseCase useCase;

  setUp(() async {
    userRepository = FakeUserRepository();
    authRepository = FakeAuthRepository();
    useCase = LoginUseCase(
      userRepository: userRepository,
      authRepository: authRepository,
    );

    await userRepository.register(
      const UserProfile(
        nombre: 'Ana',
        apellido: 'Gómez',
        tipoDocumento: DocumentType.cedulaCiudadania,
        numeroDocumento: '123456789',
        usuario: 'ana1',
        sexo: Sex.femenino,
        tokenRecuperacion: '1234',
      ),
      'password123',
    );
  });

  test('crea una sesión con nombre/apellido del perfil cuando las credenciales son correctas',
      () async {
    final session = await useCase(usuario: 'ana1', password: 'password123');

    expect(session.subject, 'ana1');
    expect(authRepository.lastGivenName, 'Ana');
    expect(authRepository.lastFamilyName, 'Gómez');
  });

  test('rechaza credenciales incorrectas sin crear sesión', () async {
    await expectLater(
      () => useCase(usuario: 'ana1', password: 'incorrecta'),
      throwsA(isA<InvalidCredentialsException>()),
    );
    expect(authRepository.lastCreatedSubject, isNull);
  });
}
