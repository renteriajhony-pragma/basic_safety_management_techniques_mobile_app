import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/usecases/create_session_usecase.dart';

import '../../helpers/fake_auth_repository.dart';

void main() {
  test('delega la creación de sesión en el repositorio', () async {
    final repository = FakeAuthRepository();
    final useCase = CreateSessionUseCase(repository);

    final session = await useCase('user-1');

    expect(session.subject, 'user-1');
    expect(repository.lastCreatedSubject, 'user-1');
  });
}
