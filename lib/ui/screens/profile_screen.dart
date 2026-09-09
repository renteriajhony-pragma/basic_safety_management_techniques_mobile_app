import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/clear_session_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/refresh_session_usecase.dart';
import '../../injection_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.session});

  final AuthSession session;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthSession _session;
  late Future<UserProfile?> _profileFuture;
  Timer? _timer;
  late Duration _remaining;
  bool _isTokenVisible = false;
  bool _isRefreshing = false;
  String? _errorMessage;

  bool get _isExpired => _remaining <= Duration.zero;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _profileFuture = sl<GetUserProfileUseCase>()();
    _remaining = _computeRemaining();
    _startTimer();
  }

  Duration _computeRemaining() {
    final remaining = _session.expiresAt.difference(DateTime.now().toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remaining = _computeRemaining();
        if (_isExpired) _isTokenVisible = false;
      });
    });
  }

  Future<void> _refreshSession() async {
    setState(() {
      _isRefreshing = true;
      _errorMessage = null;
    });

    try {
      final newSession = await sl<RefreshSessionUseCase>()(_session);
      setState(() {
        _session = newSession;
        _remaining = _computeRemaining();
      });
      _startTimer();
    } catch (_) {
      setState(() => _errorMessage = 'No se pudo refrescar la sesión');
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Future<void> _logout() async {
    await sl<ClearSessionUseCase>()();
    if (mounted) context.go('/');
  }

  String _formatRemaining(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SessionStatusCard(
                isExpired: _isExpired,
                isRefreshing: _isRefreshing,
                formatted: _formatRemaining(_remaining),
                onRefresh: _refreshSession,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              const _SectionLabel('Desde el token firmado (JWT)'),
              _ProfileField('Nombre', _session.givenName ?? '—'),
              _ProfileField('Apellido', _session.familyName ?? '—'),
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
              _MaskedProfileField(
                label: 'Token de recuperación',
                value: profile?.tokenRecuperacion ?? '—',
                isVisible: _isTokenVisible,
                isToggleEnabled: !_isExpired,
                onToggle: () => setState(() => _isTokenVisible = !_isTokenVisible),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SessionStatusCard extends StatelessWidget {
  const _SessionStatusCard({
    required this.isExpired,
    required this.isRefreshing,
    required this.formatted,
    required this.onRefresh,
  });

  final bool isExpired;
  final bool isRefreshing;
  final String formatted;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isExpired ? 'Sesión expirada' : 'Expira en $formatted',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isExpired ? Theme.of(context).colorScheme.error : null,
                ),
              ),
            ),
            TextButton(
              onPressed: isRefreshing ? null : onRefresh,
              child: isRefreshing
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Refrescar sesión'),
            ),
          ],
        ),
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
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _MaskedProfileField extends StatelessWidget {
  const _MaskedProfileField({
    required this.label,
    required this.value,
    required this.isVisible,
    required this.isToggleEnabled,
    required this.onToggle,
  });

  final String label;
  final String value;
  final bool isVisible;
  final bool isToggleEnabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Expanded(
            child: Text(
              isVisible ? value : '•' * value.length,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
            tooltip: isVisible ? 'Ocultar' : 'Mostrar',
            onPressed: isToggleEnabled ? onToggle : null,
          ),
        ],
      ),
    );
  }
}
