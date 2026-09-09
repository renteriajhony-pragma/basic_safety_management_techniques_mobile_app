import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:security_app/domain/entities/auth_session.dart';
import 'package:security_app/domain/entities/document_type.dart';
import 'package:security_app/domain/entities/sex.dart';
import 'package:security_app/domain/entities/user_profile.dart';
import 'package:security_app/domain/usecases/clear_session_usecase.dart';
import 'package:security_app/domain/usecases/get_user_profile_usecase.dart';
import 'package:security_app/domain/usecases/refresh_session_usecase.dart';
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

  Future<void> registerSampleUser() => userRepository.register(
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

  setUp(() {
    authRepository = FakeAuthRepository();
    userRepository = FakeUserRepository();
    sl.registerLazySingleton(() => ClearSessionUseCase(authRepository));
    sl.registerLazySingleton(() => GetUserProfileUseCase(userRepository));
    sl.registerLazySingleton(() => RefreshSessionUseCase(authRepository));
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
      'muestra los datos del token y del perfil, con el token de recuperación oculto por defecto',
      (tester) async {
    await registerSampleUser();
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
    await tester.pump();
    await tester.pump();

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Gómez'), findsOneWidget);
    expect(find.text('ana1'), findsOneWidget);
    expect(find.text('Cédula de ciudadanía'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);
    expect(find.text('Femenino'), findsOneWidget);
    expect(find.text('1234'), findsNothing);
    expect(find.text('•' * '1234'.length), findsOneWidget);
  });

  testWidgets('revela el token de recuperación al tocar el ícono de visibilidad',
      (tester) async {
    await registerSampleUser();
    final session = AuthSession(
      token: 'token',
      subject: 'ana1',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: buildRouter(session)),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    expect(find.text('1234'), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets(
      'el ícono para revelar el token está deshabilitado y la sesión se muestra expirada',
      (tester) async {
    await registerSampleUser();
    final session = AuthSession(
      token: 'token',
      subject: 'ana1',
      expiresAt: DateTime.now().toUtc().subtract(const Duration(seconds: 1)),
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: buildRouter(session)),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Sesión expirada'), findsOneWidget);

    final iconButton = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.visibility),
        matching: find.byType(IconButton),
      ),
    );
    expect(iconButton.onPressed, isNull);
  });

  testWidgets('muestra la cuenta regresiva mientras la sesión está activa',
      (tester) async {
    await registerSampleUser();
    final session = AuthSession(
      token: 'token',
      subject: 'ana1',
      expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 5)),
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: buildRouter(session)),
    );
    await tester.pump();
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            RegExp(r'^Expira en \d{2}:\d{2}$').hasMatch(widget.data!),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'refrescar sesión genera un nuevo token y actualiza la cuenta regresiva',
      (tester) async {
    await registerSampleUser();
    final session = AuthSession(
      token: 'token',
      subject: 'ana1',
      expiresAt: DateTime.now().toUtc().subtract(const Duration(seconds: 1)),
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: buildRouter(session)),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Sesión expirada'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Refrescar sesión'));
    await tester.pump();
    await tester.pump();

    expect(authRepository.lastCreatedSubject, 'ana1');
    expect(find.text('Sesión expirada'), findsNothing);
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
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.text('pantalla de login'), findsOneWidget);
    expect(await authRepository.getSession(), isNull);
  });
}
