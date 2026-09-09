import 'package:flutter/material.dart';

class SecureEndpoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endpoint Protegido'),
      ),
      body: Center(
        child: Text('Este es un endpoint protegido'),
      ),
    );
  }
}
