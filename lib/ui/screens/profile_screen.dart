import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/clear_session_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../injection_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.session});

  final AuthSession session;

  Future<void> _logout(BuildContext context) async {
    await sl<ClearSessionUseCase>()();
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: FutureBuilder<UserProfile?>(
        future: sl<GetUserProfileUseCase>()(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionLabel('Desde el token firmado (JWT)'),
              _ProfileField('Nombre', session.givenName ?? '—'),
              _ProfileField('Apellido', session.familyName ?? '—'),
              const SizedBox(height: 24),
              const _SectionLabel('Desde almacenamiento cifrado (AES-GCM)'),
              _ProfileField('Usuario', profile?.usuario ?? '—'),
              _ProfileField(
                'Tipo de documento',
                profile?.tipoDocumento.label ?? '—',
              ),
              _ProfileField(
                'Número de documento',
                profile?.numeroDocumento ?? '—',
              ),
              _ProfileField('Sexo', profile?.sexo.label ?? '—'),
              _ProfileField(
                'Token de recuperación',
                profile?.tokenRecuperacion ?? '—',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
