import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/usecases/get_session_usecase.dart';

import '../../helpers/fake_auth_repository.dart';

void main() {
  test('delega la consulta de sesión en el repositorio', () async {
    final repository = FakeAuthRepository();
    await repository.createSession('user-1');
    final useCase = GetSessionUseCase(repository);

    final session = await useCase();

    expect(session, isNotNull);
    expect(session!.subject, 'user-1');
  });

  test('retorna null cuando el repositorio no tiene sesión', () async {
    final repository = FakeAuthRepository();
    final useCase = GetSessionUseCase(repository);

    final session = await useCase();

    expect(session, isNull);
  });
}
