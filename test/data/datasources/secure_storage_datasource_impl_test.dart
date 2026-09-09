import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/secure_storage_datasource_impl.dart';

void main() {
  late SecureStorageDatasourceImpl datasource;

  setUp(() {
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform({});
    datasource = SecureStorageDatasourceImpl();
  });

  test('save y read devuelven el valor almacenado', () async {
    await datasource.save('key', 'value');

    final value = await datasource.read('key');

    expect(value, 'value');
  });

  test('read devuelve null cuando la clave no existe', () async {
    final value = await datasource.read('unknown');

    expect(value, isNull);
  });

  test('delete elimina el valor almacenado', () async {
    await datasource.save('key', 'value');

    await datasource.delete('key');

    expect(await datasource.read('key'), isNull);
  });
}
