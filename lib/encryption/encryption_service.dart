import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  String encrypt(String data) {
    var bytes = utf8.encode(data);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  String decrypt(String encryptedData) {
    // Implementación de descifrado
    return encryptedData;
  }
}
