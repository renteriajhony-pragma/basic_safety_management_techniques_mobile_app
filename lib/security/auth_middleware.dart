import 'package:flutter/material.dart';
import 'security_config.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;

  AuthMiddleware({required this.child});

  @override
  Widget build(BuildContext context) {
    // Implementación del middleware de autenticación
    return child;
  }
}
