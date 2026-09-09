import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/exceptions/invalid_subject_exception.dart';
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

  test('rechaza un subject inválido sin llamar al repositorio', () async {
    final repository = FakeAuthRepository();
    final useCase = CreateSessionUseCase(repository);

    await expectLater(
      () => useCase('a'),
      throwsA(isA<InvalidSubjectException>()),
    );
    expect(repository.lastCreatedSubject, isNull);
  });
}
