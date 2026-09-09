import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/auth/token_manager.dart';

void main() {
  test('Generar token', () {
    var tokenManager = TokenManager();
    var token = tokenManager.generateToken('data');
    expect(token, isNotNull);
  });
}
