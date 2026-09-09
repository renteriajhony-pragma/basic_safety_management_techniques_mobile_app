import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/services/secure_storage_service.dart';

void main() {
  late SecureStorageService storageService;

  setUp(() {
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform({});
    storageService = SecureStorageService();
  });

  test('save y read devuelven el valor almacenado', () async {
    await storageService.save('key', 'value');

    final value = await storageService.read('key');

    expect(value, 'value');
  });

  test('read devuelve null cuando la clave no existe', () async {
    final value = await storageService.read('unknown');

    expect(value, isNull);
  });

  test('delete elimina el valor almacenado', () async {
    await storageService.save('key', 'value');

    await storageService.delete('key');

    expect(await storageService.read('key'), isNull);
  });
}
