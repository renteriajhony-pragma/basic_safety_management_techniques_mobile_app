import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:security_app/domain/usecases/clear_session_usecase.dart';
import 'package:security_app/injection_container.dart';
import 'package:security_app/ui/screens/secure_endpoint_screen.dart';

import '../../helpers/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;

  GoRouter buildRouter() => GoRouter(
        initialLocation: '/secure',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Text('pantalla de login'),
          ),
          GoRoute(
            path: '/secure',
            builder: (context, state) => const SecureEndpointScreen(),
          ),
        ],
      );

  setUp(() async {
    repository = FakeAuthRepository();
    await repository.createSession('user-1');
    sl.registerLazySingleton(() => ClearSessionUseCase(repository));
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('cerrar sesión borra el token y navega al login',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.text('pantalla de login'), findsOneWidget);
    expect(await repository.getSession(), isNull);
  });
}
