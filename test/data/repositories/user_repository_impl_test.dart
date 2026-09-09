import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/repositories/user_repository_impl.dart';
import 'package:security_app/domain/entities/document_type.dart';
import 'package:security_app/domain/entities/sex.dart';
import 'package:security_app/domain/entities/user_profile.dart';

import '../../helpers/fake_password_hasher.dart';
import '../../helpers/fake_secure_storage_datasource.dart';

UserProfile _profile() => const UserProfile(
      nombre: 'Ana',
      apellido: 'Gómez',
      tipoDocumento: DocumentType.cedulaCiudadania,
      numeroDocumento: '123456789',
      usuario: 'ana1',
      sexo: Sex.femenino,
      tokenRecuperacion: '1234',
    );

void main() {
  late UserRepositoryImpl repository;

  setUp(() {
    repository = UserRepositoryImpl(
      storageDatasource: FakeSecureStorageDatasource(),
      passwordHasher: FakePasswordHasher(),
    );
  });

  test('hasRegisteredUser es false antes de registrar', () async {
    expect(await repository.hasRegisteredUser(), isFalse);
  });

  test('register persiste el perfil y permite recuperarlo', () async {
    await repository.register(_profile(), 'password123');

    final profile = await repository.getProfile();

    expect(await repository.hasRegisteredUser(), isTrue);
    expect(profile?.usuario, 'ana1');
    expect(profile?.nombre, 'Ana');
    expect(profile?.apellido, 'Gómez');
    expect(profile?.tipoDocumento, DocumentType.cedulaCiudadania);
    expect(profile?.sexo, Sex.femenino);
    expect(profile?.tokenRecuperacion, '1234');
  });

  test('verifyCredentials acepta usuario y contraseña correctos', () async {
    await repository.register(_profile(), 'password123');

    expect(await repository.verifyCredentials('ana1', 'password123'), isTrue);
  });

  test('verifyCredentials rechaza una contraseña incorrecta', () async {
    await repository.register(_profile(), 'password123');

    expect(await repository.verifyCredentials('ana1', 'incorrecta'), isFalse);
  });

  test('verifyCredentials rechaza un usuario no registrado', () async {
    await repository.register(_profile(), 'password123');

    expect(await repository.verifyCredentials('otro', 'password123'), isFalse);
  });
}
