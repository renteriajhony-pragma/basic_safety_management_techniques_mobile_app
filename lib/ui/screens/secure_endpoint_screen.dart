import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/clear_session_usecase.dart';
import '../../injection_container.dart';

class SecureEndpointScreen extends StatelessWidget {
  const SecureEndpointScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await sl<ClearSessionUseCase>()();
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Endpoint Protegido'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Este es un endpoint protegido'),
      ),
    );
  }
}
