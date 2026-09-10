import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:security_app/domain/usecases/register_user_usecase.dart';
import 'package:security_app/injection_container.dart';
import 'package:security_app/ui/screens/register_screen.dart';

import '../../helpers/fake_user_repository.dart';

void main() {
  late FakeUserRepository userRepository;

  GoRouter buildRouter() => GoRouter(
        initialLocation: '/register',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Text('pantalla de login'),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
      );

  setUp(() {
    userRepository = FakeUserRepository();
    sl.registerLazySingleton(() => RegisterUserUseCase(userRepository));
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
      'registra al usuario y vuelve a login cuando todos los campos son válidos',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre'),
      'Ana',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Apellido'),
      'Gómez',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Número de documento'),
      '123456789',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Usuario'),
      'ana1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Contraseña'),
      'password123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Token de recuperación (4 dígitos)'),
      '1234',
    );

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Registrarse'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrarse'));
    await tester.pumpAndSettle();

    expect(find.text('pantalla de login'), findsOneWidget);
    expect(userRepository.storedProfile?.usuario, 'ana1');
    expect(userRepository.storedProfile?.nombre, 'Ana');
    expect(userRepository.storedPassword, 'password123');
  });

  testWidgets('muestra errores de validación si se envía el formulario vacío',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Registrarse'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrarse'));
    await tester.pump();

    expect(find.text('El nombre es un campo obligatorio'), findsOneWidget);
    expect(userRepository.storedProfile, isNull);
  });
}
