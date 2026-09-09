import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'injection_container.dart';
import 'ui/router/app_router.dart';

Future<void> main() async {
  await dotenv.load();
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
