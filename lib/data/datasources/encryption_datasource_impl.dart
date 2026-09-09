import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import '../config/security_config.dart';
import 'encryption_datasource.dart';

class EncryptionDatasourceImpl implements EncryptionDatasource {
  EncryptionDatasourceImpl({AesGcm? algorithm})
      : _algorithm = algorithm ?? AesGcm.with256bits();

  final AesGcm _algorithm;

  @override
  Future<String> encrypt(String plainText) async {
    final secretBox = await _algorithm.encryptString(
      plainText,
      secretKey: SecurityConfig.encryptionKey,
    );
    return base64.encode(secretBox.concatenation());
  }

  @override
  Future<String> decrypt(String cipherText) {
    final secretBox = SecretBox.fromConcatenation(
      base64.decode(cipherText),
      nonceLength: _algorithm.nonceLength,
      macLength: _algorithm.macAlgorithm.macLength,
    );
    return _algorithm.decryptString(
      secretBox,
      secretKey: SecurityConfig.encryptionKey,
    );
  }
}
