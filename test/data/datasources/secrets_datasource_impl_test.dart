import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/secrets_datasource_impl.dart';

void main() {
  late SecretsDatasourceImpl secretsDatasource;

  setUp(() {
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform({});
    secretsDatasource = SecretsDatasourceImpl();
  });

  test('genera un valor aleatorio en el primer acceso', () async {
    final value = await secretsDatasource.getOrCreate('some_key');

    expect(value, isNotEmpty);
  });

  test('devuelve el mismo valor en accesos posteriores', () async {
    final first = await secretsDatasource.getOrCreate('some_key');
    final second = await secretsDatasource.getOrCreate('some_key');

    expect(second, first);
  });

  test('genera valores distintos para claves distintas', () async {
    final a = await secretsDatasource.getOrCreate('key_a');
    final b = await secretsDatasource.getOrCreate('key_b');

    expect(a, isNot(equals(b)));
  });
}
