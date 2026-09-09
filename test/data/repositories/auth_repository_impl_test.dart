import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/token_datasource_impl.dart';
import 'package:security_app/data/repositories/auth_repository_impl.dart';
import 'package:security_app/domain/repositories/auth_repository.dart';

import '../../helpers/fake_secure_storage_datasource.dart';
import '../../helpers/test_env.dart';

void main() {
  late AuthRepository authRepository;
  late FakeSecureStorageDatasource storageDatasource;

  setUpAll(loadTestEnv);

  setUp(() {
    storageDatasource = FakeSecureStorageDatasource();
    authRepository = AuthRepositoryImpl(
      tokenDatasource: TokenDatasourceImpl(),
      storageDatasource: storageDatasource,
    );
  });

  test('createSession genera y persiste una sesión válida', () async {
    final session = await authRepository.createSession('user-1');

    expect(session.subject, 'user-1');
    expect(session.isValid, isTrue);
  });

  test('getSession recupera la sesión persistida', () async {
    await authRepository.createSession('user-1');

    final session = await authRepository.getSession();

    expect(session, isNotNull);
    expect(session!.subject, 'user-1');
  });

  test('getSession retorna null cuando no hay token almacenado', () async {
    final session = await authRepository.getSession();

    expect(session, isNull);
  });

  test('getSession retorna null cuando el token almacenado es inválido', () async {
    await storageDatasource.save('auth_token', 'token-invalido');

    final session = await authRepository.getSession();

    expect(session, isNull);
  });
}
