import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/encryption_datasource_impl.dart';

import '../../helpers/fake_secrets_datasource.dart';

void main() {
  late EncryptionDatasourceImpl encryptionDatasource;

  setUp(() {
    encryptionDatasource = EncryptionDatasourceImpl(
      secretsDatasource: FakeSecretsDatasource(),
    );
  });

  test('descifra lo que fue cifrado y obtiene el texto original', () async {
    final cipherText = await encryptionDatasource.encrypt('dato sensible');

    final plainText = await encryptionDatasource.decrypt(cipherText);

    expect(plainText, 'dato sensible');
  });

  test('el texto cifrado no contiene el texto plano', () async {
    final cipherText = await encryptionDatasource.encrypt('dato sensible');

    expect(cipherText, isNot(contains('dato sensible')));
  });

  test('cifrar el mismo texto dos veces produce resultados distintos', () async {
    final first = await encryptionDatasource.encrypt('dato sensible');
    final second = await encryptionDatasource.encrypt('dato sensible');

    expect(first, isNot(equals(second)));
  });

  test('rechaza un texto cifrado manipulado', () async {
    final cipherText = await encryptionDatasource.encrypt('dato sensible');
    final tampered = '${cipherText.substring(0, cipherText.length - 4)}AAAA';

    expect(
      () => encryptionDatasource.decrypt(tampered),
      throwsA(isA<Exception>()),
    );
  });
}
