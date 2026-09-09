import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/storage/secure_storage_service.dart';

void main() {
  test('Guardar y recuperar datos', () async {
    var storageService = SecureStorageService();
    await storageService.saveData('key', 'value');
    var data = await storageService.getData('key');
    expect(data, 'value');
  });
}
