import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/entities/auth_session.dart';
import 'package:security_app/domain/usecases/refresh_session_usecase.dart';

import '../../helpers/fake_auth_repository.dart';

void main() {
  test('crea una nueva sesión con el mismo subject y claims que la actual',
      () async {
    final repository = FakeAuthRepository();
    final useCase = RefreshSessionUseCase(repository);
    final currentSession = AuthSession(
      token: 'old-token',
      subject: 'ana1',
      expiresAt: DateTime.now().toUtc(),
      givenName: 'Ana',
      familyName: 'Gómez',
    );

    final newSession = await useCase(currentSession);

    expect(newSession.subject, 'ana1');
    expect(repository.lastCreatedSubject, 'ana1');
    expect(repository.lastGivenName, 'Ana');
    expect(repository.lastFamilyName, 'Gómez');
  });
}
