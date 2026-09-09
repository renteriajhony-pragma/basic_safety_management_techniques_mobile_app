import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/exceptions/invalid_subject_exception.dart';
import '../../domain/usecases/create_session_usecase.dart';
import '../../domain/validators/subject_validator.dart';
import '../../injection_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  String? _validateSubject(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Ingresa un usuario';
    if (!SubjectValidator.isValid(trimmed)) {
      return 'Usa entre ${SubjectValidator.minLength} y '
          '${SubjectValidator.maxLength} caracteres (letras, números, "-" o "_")';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await sl<CreateSessionUseCase>()(_subjectController.text.trim());
      if (mounted) context.go('/secure');
    } on InvalidSubjectException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = 'No se pudo iniciar sesión');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: _validateSubject,
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
