import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/models/auth_session.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({
    super.key,
    required this.authRepository,
    required this.child,
  });

  final AuthRepository authRepository;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthSession?>(
      future: authRepository.getSession(),
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
