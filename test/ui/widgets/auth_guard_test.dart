import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/repositories/auth_repository.dart';
import 'package:security_app/data/services/token_service.dart';
import 'package:security_app/ui/widgets/auth_guard.dart';

import '../../helpers/fake_key_value_storage.dart';

void main() {
  Future<AuthRepository> buildRepositoryWithSession({
    required bool valid,
  }) async {
    final repository = AuthRepository(
      tokenService: TokenService(),
      storage: FakeKeyValueStorage(),
    );

    if (valid) {
      await repository.createSession('user-1');
    }

    return repository;
  }

  testWidgets('muestra el contenido protegido cuando hay una sesión válida',
      (tester) async {
    final repository = await buildRepositoryWithSession(valid: true);

    await tester.pumpWidget(MaterialApp(
      home: AuthGuard(
        authRepository: repository,
        child: const Text('contenido protegido'),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('contenido protegido'), findsOneWidget);
  });

  testWidgets('muestra el mensaje de no autorizado cuando no hay sesión',
      (tester) async {
    final repository = await buildRepositoryWithSession(valid: false);

    await tester.pumpWidget(MaterialApp(
      home: AuthGuard(
        authRepository: repository,
        child: const Text('contenido protegido'),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('contenido protegido'), findsNothing);
    expect(find.text('Acceso no autorizado'), findsOneWidget);
  });
}
