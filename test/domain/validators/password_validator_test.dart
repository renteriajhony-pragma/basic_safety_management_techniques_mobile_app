import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/validators/password_validator.dart';

void main() {
  test('acepta una contraseña de longitud válida', () {
    expect(PasswordValidator.isValid('password123'), isTrue);
  });

  test('rechaza una contraseña demasiado corta', () {
    expect(PasswordValidator.isValid('short1'), isFalse);
  });

  test('rechaza una contraseña demasiado larga', () {
    expect(PasswordValidator.isValid('a' * 65), isFalse);
  });

  test('acepta cualquier caracter, incluidos especiales', () {
    expect(PasswordValidator.isValid(r'p@ssw0rd!#$'), isTrue);
  });
}
