import 'dart:convert';
import 'package:crypto/crypto.dart';

class TokenManager {
  String generateToken(String data) {
    var bytes = utf8.encode(data);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool validateToken(String token) {
    // Implementación de validación de token
    return true;
  }
}
