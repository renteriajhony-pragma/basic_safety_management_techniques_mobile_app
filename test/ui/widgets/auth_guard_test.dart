import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/token_datasource_impl.dart';
import 'package:security_app/data/repositories/auth_repository_impl.dart';
import 'package:security_app/domain/usecases/get_session_usecase.dart';
import 'package:security_app/ui/widgets/auth_guard.dart';

import '../../helpers/fake_secrets_datasource.dart';
import '../../helpers/fake_secure_storage_datasource.dart';

void main() {
  Future<GetSessionUseCase> buildUseCaseWithSession({required bool valid}) async {
    final repository = AuthRepositoryImpl(
      tokenDatasource: TokenDatasourceImpl(
        secretsDatasource: FakeSecretsDatasource(),
      ),
      storageDatasource: FakeSecureStorageDatasource(),
    );

    if (valid) {
      await repository.createSession('user-1');
    }

    return GetSessionUseCase(repository);
  }

  testWidgets('muestra el contenido protegido cuando hay una sesión válida',
      (tester) async {
    final getSessionUseCase = await buildUseCaseWithSession(valid: true);

    await tester.pumpWidget(MaterialApp(
      home: AuthGuard(
        getSessionUseCase: getSessionUseCase,
        child: const Text('contenido protegido'),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('contenido protegido'), findsOneWidget);
  });

  testWidgets('muestra el mensaje de no autorizado cuando no hay sesión',
      (tester) async {
    final getSessionUseCase = await buildUseCaseWithSession(valid: false);

    await tester.pumpWidget(MaterialApp(
      home: AuthGuard(
        getSessionUseCase: getSessionUseCase,
        child: const Text('contenido protegido'),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('contenido protegido'), findsNothing);
    expect(find.text('Acceso no autorizado'), findsOneWidget);
  });
}
