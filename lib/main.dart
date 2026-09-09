import 'package:flutter/material.dart';

import 'injection_container.dart';
import 'ui/router/app_router.dart';

void main() {
  setupDependencies();
  runApp(const SecurityApp());
}

class SecurityApp extends StatelessWidget {
  const SecurityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Security App',
      routerConfig: appRouter,
    );
  }
}
