import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/document_type.dart';
import '../../domain/entities/sex.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/exceptions/invalid_password_exception.dart';
import '../../domain/exceptions/invalid_subject_exception.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/validators/subject_validator.dart';
import '../../injection_container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _numeroDocumentoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenRecuperacionController = TextEditingController();

  DocumentType _tipoDocumento = DocumentType.cedulaCiudadania;
  Sex _sexo = Sex.masculino;
  bool _isLoading = false;
  String? _errorMessage;

  String? _requiredValidator(String? value, {required String label}) {
    if (value == null || value.trim().isEmpty) return '$label es un campo obligatorio';
    return null;
  }

  String? _usuarioValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'El usuario es obligatorio';
    if (!SubjectValidator.isValid(trimmed)) {
      return 'Usa entre ${SubjectValidator.minLength} y '
          '${SubjectValidator.maxLength} caracteres (letras, números, "-" o "_")';
    }
    return null;
  }

  String? _tokenRecuperacionValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'El token de recuperación es obligatorio';
    if (!RegExp(r'^\d{4}$').hasMatch(trimmed)) {
      return 'Debe ser un número de 4 dígitos';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final profile = UserProfile(
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      tipoDocumento: _tipoDocumento,
      numeroDocumento: _numeroDocumentoController.text.trim(),
      usuario: _usuarioController.text.trim(),
      sexo: _sexo,
      tokenRecuperacion: _tokenRecuperacionController.text.trim(),
    );

    try {
      await sl<RegisterUserUseCase>()(profile, _passwordController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado. Inicia sesión.')),
        );
        context.go('/');
      }
    } on InvalidSubjectException catch (e) {
      setState(() => _errorMessage = e.message);
    } on InvalidPasswordException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = 'No se pudo completar el registro');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _numeroDocumentoController.dispose();
    _usuarioController.dispose();
    _passwordController.dispose();
    _tokenRecuperacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => _requiredValidator(v, label: 'El nombre'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) => _requiredValidator(v, label: 'El apellido'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DocumentType>(
                initialValue: _tipoDocumento,
                decoration: const InputDecoration(labelText: 'Tipo de documento'),
                items: DocumentType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _tipoDocumento = value!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numeroDocumentoController,
                decoration: const InputDecoration(labelText: 'Número de documento'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    _requiredValidator(v, label: 'El número de documento'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usuarioController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: _usuarioValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (v) => _requiredValidator(v, label: 'La contraseña'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Sex>(
                initialValue: _sexo,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: Sex.values
                    .map(
                      (sex) => DropdownMenuItem(value: sex, child: Text(sex.label)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _sexo = value!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tokenRecuperacionController,
                decoration: const InputDecoration(
                  labelText: 'Token de recuperación (4 dígitos)',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: _tokenRecuperacionValidator,
              ),
              const SizedBox(height: 8),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
