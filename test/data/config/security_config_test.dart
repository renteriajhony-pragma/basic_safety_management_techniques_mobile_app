import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/config/security_config.dart';

void main() {
  test('secretKey se obtiene desde las variables de entorno', () {
    dotenv.loadFromString(envString: 'JWT_SECRET=abc123\nJWT_EXPIRATION_MINUTES=60');

    expect(SecurityConfig.secretKey, 'abc123');
  });

  test('tokenLifetime se obtiene desde las variables de entorno', () {
    dotenv.loadFromString(envString: 'JWT_SECRET=abc123\nJWT_EXPIRATION_MINUTES=45');

    expect(SecurityConfig.tokenLifetime, const Duration(minutes: 45));
  });
}
