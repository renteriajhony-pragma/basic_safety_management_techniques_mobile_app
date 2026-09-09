import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/config/security_config.dart';

void main() {
  test('tokenLifetime es de 60 minutos', () {
    expect(SecurityConfig.tokenLifetime, const Duration(minutes: 60));
  });
}
