import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/password_hasher_impl.dart';

void main() {
  late PasswordHasherImpl hasher;

  setUp(() {
    hasher = PasswordHasherImpl();
  });

  test('verifica correctamente la contraseña que fue hasheada', () async {
    final encoded = await hasher.hash('password123');

    expect(await hasher.verify('password123', encoded), isTrue);
  });

  test('rechaza una contraseña incorrecta', () async {
    final encoded = await hasher.hash('password123');

    expect(await hasher.verify('otra-clave', encoded), isFalse);
  });

  test('el hash no contiene la contraseña en texto plano', () async {
    final encoded = await hasher.hash('password123');

    expect(encoded, isNot(contains('password123')));
  });

  test('hashear la misma contraseña dos veces produce salidas distintas', () async {
    final first = await hasher.hash('password123');
    final second = await hasher.hash('password123');

    expect(first, isNot(equals(second)));
  });
}
