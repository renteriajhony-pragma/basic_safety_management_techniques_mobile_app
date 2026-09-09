import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecurityConfig {
  static String get secretKey => dotenv.get('JWT_SECRET');
}
