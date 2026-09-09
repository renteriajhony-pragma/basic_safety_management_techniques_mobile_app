import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'hardened_flutter_secure_storage.dart';
import 'secrets_datasource.dart';

class SecretsDatasourceImpl implements SecretsDatasource {
  SecretsDatasourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? hardenedSecureStorage;

  static const _keyLengthInBytes = 32;

  final FlutterSecureStorage _storage;

  @override
  Future<String> getOrCreate(String key) async {
    final existing = await _storage.read(key: key);
    if (existing != null) return existing;

    final generated = _generateRandomValue();
    await _storage.write(key: key, value: generated);
    return generated;
  }

  String _generateRandomValue() {
    final random = Random.secure();
    final bytes = List<int>.generate(_keyLengthInBytes, (_) => random.nextInt(256));
    return base64.encode(bytes);
  }
}
