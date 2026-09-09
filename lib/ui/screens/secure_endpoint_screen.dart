import 'package:flutter/material.dart';

class SecureEndpointScreen extends StatelessWidget {
  const SecureEndpointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Endpoint Protegido'),
      ),
      body: const Center(
        child: Text('Este es un endpoint protegido'),
      ),
    );
  }
}
