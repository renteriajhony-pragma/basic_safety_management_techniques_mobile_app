import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/security/security_config.dart';

void main() {
  test('Configuración de seguridad', () {
    expect(SecurityConfig.secretKey, 'mySecretKey');
  });
}
