import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:security_app/domain/entities/auth_session.dart';
import 'package:security_app/domain/entities/document_type.dart';
import 'package:security_app/domain/entities/sex.dart';
import 'package:security_app/domain/entities/user_profile.dart';
import 'package:security_app/domain/usecases/clear_session_usecase.dart';
import 'package:security_app/domain/usecases/get_user_profile_usecase.dart';
import 'package:security_app/injection_container.dart';
import 'package:security_app/ui/screens/profile_screen.dart';

import '../../helpers/fake_auth_repository.dart';
import '../../helpers/fake_user_repository.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeUserRepository userRepository;

  GoRouter buildRouter(AuthSession session) => GoRouter(
        initialLocation: '/profile',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Text('pantalla de login'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(session: session),
          ),
        ],
      );

  setUp(() {
    authRepository = FakeAuthRepository();
    userRepository = FakeUserRepository();
    sl.registerLazySingleton(() => ClearSessionUseCase(authRepository));
    sl.registerLazySingleton(() => GetUserProfileUseCase(userRepository));
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('muestra los datos del token y del perfil almacenado',
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
    final session = AuthSession(
      token: 'token',
      subject: 'ana1',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      givenName: 'Ana',
      familyName: 'Gómez',
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: buildRouter(session)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Gómez'), findsOneWidget);
    expect(find.text('ana1'), findsOneWidget);
    expect(find.text('Cédula de ciudadanía'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);
    expect(find.text('Femenino'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
  });

  testWidgets('cerrar sesión borra el token y navega al login', (tester) async {
    await authRepository.createSession('ana1');
    final session = AuthSession(
      token: 'token',
      subject: 'ana1',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: buildRouter(session)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.text('pantalla de login'), findsOneWidget);
    expect(await authRepository.getSession(), isNull);
  });
}
