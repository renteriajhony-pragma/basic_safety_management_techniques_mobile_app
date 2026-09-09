import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:security_app/domain/entities/document_type.dart';
import 'package:security_app/domain/entities/sex.dart';
import 'package:security_app/domain/entities/user_profile.dart';
import 'package:security_app/domain/usecases/login_usecase.dart';
import 'package:security_app/injection_container.dart';
import 'package:security_app/ui/screens/login_screen.dart';

import '../../helpers/fake_auth_repository.dart';
import '../../helpers/fake_user_repository.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeUserRepository userRepository;

  GoRouter buildRouter() => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
          GoRoute(
            path: '/register',
            builder: (context, state) => const Text('pantalla de registro'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const Text('pantalla protegida'),
          ),
        ],
      );

  setUp(() {
    authRepository = FakeAuthRepository();
    userRepository = FakeUserRepository();
    sl.registerLazySingleton(
      () => LoginUseCase(
        userRepository: userRepository,
        authRepository: authRepository,
      ),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
      'navega al perfil tras iniciar sesión con credenciales correctas',
      (tester) async {
    await userRepository.register(
      const UserProfile(
        nombre: 'Ana',
        apellido: 'Gómez',
        tipoDocumento: DocumentType.cedulaCiudadania,
        numeroDocumento: '123456789',
        usuario: 'ana1',
        sexo: Sex.femenino,
        tokenRecuperacion: '1234',
      ),
      'password123',
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Usuario'),
      'ana1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Contraseña'),
      'password123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('pantalla protegida'), findsOneWidget);
    expect(authRepository.lastCreatedSubject, 'ana1');
  });

  testWidgets('muestra un error cuando las credenciales son incorrectas',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Usuario'),
      'ana1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Contraseña'),
      'incorrecta',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Usuario o contraseña incorrectos'), findsOneWidget);
    expect(authRepository.lastCreatedSubject, isNull);
  });

  testWidgets('muestra errores de validación si los campos están vacíos',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar sesión'));
    await tester.pump();

    expect(find.text('El usuario es un campo obligatorio'), findsOneWidget);
    expect(find.text('La contraseña es un campo obligatorio'), findsOneWidget);
  });

  testWidgets('navega a la pantalla de registro al tocar el enlace',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));

    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();

    expect(find.text('pantalla de registro'), findsOneWidget);
  });
}
