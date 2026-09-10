import 'package:go_router/go_router.dart';

import '../../domain/usecases/get_session_usecase.dart';
import '../../injection_container.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/register_screen.dart';
import '../widgets/auth_guard.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => AuthGuard(
        getSessionUseCase: sl<GetSessionUseCase>(),
        builder: (context, session) => ProfileScreen(session: session),
      ),
    ),
  ],
);
