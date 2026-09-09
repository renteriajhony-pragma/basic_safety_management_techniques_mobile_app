import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/repositories/auth_repository.dart';
import 'package:security_app/data/services/token_service.dart';

import '../../helpers/fake_key_value_storage.dart';

void main() {
  late AuthRepository authRepository;
  late FakeKeyValueStorage storage;

  setUp(() {
    storage = FakeKeyValueStorage();
    authRepository = AuthRepository(
      tokenService: TokenService(),
      storage: storage,
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
    await storage.save('auth_token', 'token-invalido');

    final session = await authRepository.getSession();

    expect(session, isNull);
  });
}
