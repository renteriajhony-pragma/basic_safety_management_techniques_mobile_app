import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'encryption_datasource.dart';
import 'hardened_flutter_secure_storage.dart';
import 'secure_storage_datasource.dart';

class SecureStorageDatasourceImpl implements SecureStorageDatasource {
  SecureStorageDatasourceImpl({
    required EncryptionDatasource encryptionDatasource,
    FlutterSecureStorage? storage,
  })  : _encryptionDatasource = encryptionDatasource,
        _storage = storage ?? hardenedSecureStorage;

  final EncryptionDatasource _encryptionDatasource;
  final FlutterSecureStorage _storage;

  @override
  Future<void> save(String key, String value) async {
    final encrypted = await _encryptionDatasource.encrypt(value);
    await _storage.write(key: key, value: encrypted);
  }

  @override
  Future<String?> read(String key) async {
    final encrypted = await _storage.read(key: key);
    if (encrypted == null) return null;
    return _encryptionDatasource.decrypt(encrypted);
  }

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
