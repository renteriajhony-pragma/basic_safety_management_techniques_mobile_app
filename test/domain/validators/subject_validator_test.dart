import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/validators/subject_validator.dart';

void main() {
  test('acepta letras, números, guion y guion bajo', () {
    expect(SubjectValidator.isValid('user_1-A'), isTrue);
  });

  test('rechaza un valor demasiado corto', () {
    expect(SubjectValidator.isValid('ab'), isFalse);
  });

  test('rechaza un valor demasiado largo', () {
    expect(SubjectValidator.isValid('a' * 33), isFalse);
  });

  test('rechaza espacios', () {
    expect(SubjectValidator.isValid('user 1'), isFalse);
  });

  test('rechaza caracteres especiales', () {
    expect(SubjectValidator.isValid('user@1'), isFalse);
  });

  test('rechaza un valor vacío', () {
    expect(SubjectValidator.isValid(''), isFalse);
  });
}
