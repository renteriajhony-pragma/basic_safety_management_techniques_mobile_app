import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/usecases/clear_session_usecase.dart';

import '../../helpers/fake_auth_repository.dart';

void main() {
  test('delega el borrado de sesión en el repositorio', () async {
    final repository = FakeAuthRepository();
    await repository.createSession('user-1');
    final useCase = ClearSessionUseCase(repository);

    await useCase();

    expect(await repository.getSession(), isNull);
  });
}
