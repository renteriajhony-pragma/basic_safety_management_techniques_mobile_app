import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:security_app/domain/usecases/create_session_usecase.dart';
import 'package:security_app/injection_container.dart';
import 'package:security_app/ui/screens/login_screen.dart';

import '../../helpers/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;

  GoRouter buildRouter() => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
          GoRoute(
            path: '/secure',
            builder: (context, state) => const Text('pantalla protegida'),
          ),
        ],
      );

  setUp(() {
    repository = FakeAuthRepository();
    sl.registerLazySingleton(() => CreateSessionUseCase(repository));
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('navega al endpoint protegido tras iniciar sesión',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.enterText(find.byType(TextFormField), 'user-1');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('pantalla protegida'), findsOneWidget);
    expect(repository.lastCreatedSubject, 'user-1');
  });

  testWidgets('muestra un error de validación si el campo está vacío',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();

    expect(find.text('Ingresa un usuario'), findsOneWidget);
    expect(repository.lastCreatedSubject, isNull);
  });
}
