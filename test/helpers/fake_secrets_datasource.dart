import 'package:security_app/data/datasources/secrets_datasource.dart';

class FakeSecretsDatasource implements SecretsDatasource {
  // A fixed, valid base64-encoded 32-byte value: usable both as an
  // arbitrary JWT signing secret and as a decodable AES-256 key.
  static const _fixedValue = 'SSiA6grczQqbeGtChNX7CZJHSHFjQZ0CJyueWhDtbm0=';

  final Map<String, String> _values = {};

  @override
  Future<String> getOrCreate(String key) async =>
      _values.putIfAbsent(key, () => _fixedValue);
}
