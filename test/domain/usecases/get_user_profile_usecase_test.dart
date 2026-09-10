import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/usecases/get_user_profile_usecase.dart';

import '../../helpers/fake_user_repository.dart';

void main() {
  test('delega la consulta del perfil en el repositorio', () async {
    final repository = FakeUserRepository();
    final useCase = GetUserProfileUseCase(repository);

    expect(await useCase(), isNull);
  });
}
