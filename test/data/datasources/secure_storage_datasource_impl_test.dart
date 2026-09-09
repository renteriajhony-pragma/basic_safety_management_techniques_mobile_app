import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/encryption_datasource_impl.dart';
import 'package:security_app/data/datasources/secure_storage_datasource_impl.dart';

import '../../helpers/test_env.dart';

void main() {
  late SecureStorageDatasourceImpl datasource;
  late Map<String, String> rawPlatformData;

  setUpAll(loadTestEnv);

  setUp(() {
    rawPlatformData = {};
    FlutterSecureStoragePlatform.instance =
        TestFlutterSecureStoragePlatform(rawPlatformData);
    datasource = SecureStorageDatasourceImpl(
      encryptionDatasource: EncryptionDatasourceImpl(),
    );
  });

  test('save y read devuelven el valor almacenado', () async {
    await datasource.save('key', 'value');

    final value = await datasource.read('key');

    expect(value, 'value');
  });

  test('el valor persistido en la plataforma esta cifrado, no en texto plano', () async {
    await datasource.save('key', 'value');

    expect(rawPlatformData['key'], isNotNull);
    expect(rawPlatformData['key'], isNot(equals('value')));
    expect(rawPlatformData['key'], isNot(contains('value')));
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
