import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/entities/document_type.dart';
import 'package:security_app/domain/entities/sex.dart';
import 'package:security_app/domain/entities/user_profile.dart';
import 'package:security_app/domain/exceptions/invalid_password_exception.dart';
import 'package:security_app/domain/exceptions/invalid_subject_exception.dart';
import 'package:security_app/domain/usecases/register_user_usecase.dart';

import '../../helpers/fake_user_repository.dart';

UserProfile _profile({String usuario = 'user_1'}) => UserProfile(
      nombre: 'Ana',
      apellido: 'Gómez',
      tipoDocumento: DocumentType.cedulaCiudadania,
      numeroDocumento: '123456789',
      usuario: usuario,
      sexo: Sex.femenino,
      tokenRecuperacion: '1234',
    );

void main() {
  test('registra el perfil cuando usuario y contraseña son válidos', () async {
    final repository = FakeUserRepository();
    final useCase = RegisterUserUseCase(repository);

    await useCase(_profile(), 'password123');

    expect(repository.storedProfile?.usuario, 'user_1');
    expect(repository.storedPassword, 'password123');
  });

  test('rechaza un usuario inválido sin llamar al repositorio', () async {
    final repository = FakeUserRepository();
    final useCase = RegisterUserUseCase(repository);

    await expectLater(
      () => useCase(_profile(usuario: 'a'), 'password123'),
      throwsA(isA<InvalidSubjectException>()),
    );
    expect(repository.storedProfile, isNull);
  });

  test('rechaza una contraseña inválida sin llamar al repositorio', () async {
    final repository = FakeUserRepository();
    final useCase = RegisterUserUseCase(repository);

    await expectLater(
      () => useCase(_profile(), 'short'),
      throwsA(isA<InvalidPasswordException>()),
    );
    expect(repository.storedProfile, isNull);
  });
}
