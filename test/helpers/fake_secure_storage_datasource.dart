import 'package:security_app/data/datasources/secure_storage_datasource.dart';

class FakeSecureStorageDatasource implements SecureStorageDatasource {
  final Map<String, String> _data = {};

  @override
  Future<void> save(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }
}
