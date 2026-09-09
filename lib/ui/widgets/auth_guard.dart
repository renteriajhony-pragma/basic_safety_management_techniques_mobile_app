import 'package:flutter/material.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/get_session_usecase.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({
    super.key,
    required this.getSessionUseCase,
    required this.child,
  });

  final GetSessionUseCase getSessionUseCase;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthSession?>(
      future: getSessionUseCase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final session = snapshot.data;
        if (session == null || !session.isValid) {
          return const Center(child: Text('Acceso no autorizado'));
        }

        return child;
      },
    );
  }
}
