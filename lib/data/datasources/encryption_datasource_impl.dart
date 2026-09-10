import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'encryption_datasource.dart';
import 'secrets_datasource.dart';

class EncryptionDatasourceImpl implements EncryptionDatasource {
  EncryptionDatasourceImpl({
    required SecretsDatasource secretsDatasource,
    AesGcm? algorithm,
  })  : _secretsDatasource = secretsDatasource,
        _algorithm = algorithm ?? AesGcm.with256bits();

  static const _encryptionKeyKey = 'encryption_key';

  final SecretsDatasource _secretsDatasource;
  final AesGcm _algorithm;

  @override
  Future<String> encrypt(String plainText) async {
    final secretBox = await _algorithm.encryptString(
      plainText,
      secretKey: await _encryptionKey(),
    );
    return base64.encode(secretBox.concatenation());
  }

  @override
  Future<String> decrypt(String cipherText) async {
    final secretBox = SecretBox.fromConcatenation(
      base64.decode(cipherText),
      nonceLength: _algorithm.nonceLength,
      macLength: _algorithm.macAlgorithm.macLength,
    );
    return _algorithm.decryptString(
      secretBox,
      secretKey: await _encryptionKey(),
    );
  }

  Future<SecretKey> _encryptionKey() async {
    final encoded = await _secretsDatasource.getOrCreate(_encryptionKeyKey);
    return SecretKey(base64.decode(encoded));
  }
}
