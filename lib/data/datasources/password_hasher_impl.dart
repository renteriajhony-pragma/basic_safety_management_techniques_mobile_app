import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'password_hasher.dart';

class PasswordHasherImpl implements PasswordHasher {
  PasswordHasherImpl({Argon2id? algorithm})
      : _algorithm = algorithm ??
            Argon2id(
              // OWASP-recommended minimum for interactive logins.
              memory: 19456,
              parallelism: 1,
              iterations: 2,
              hashLength: 32,
            );

  static const _saltLengthInBytes = 16;

  final Argon2id _algorithm;

  @override
  Future<String> hash(String password) async {
    final salt = _generateSalt();
    final hashBytes = await _deriveBytes(password, salt);
    return '${base64.encode(salt)}:${base64.encode(hashBytes)}';
  }

  @override
  Future<bool> verify(String password, String encodedHash) async {
    final parts = encodedHash.split(':');
    if (parts.length != 2) return false;

    final salt = base64.decode(parts[0]);
    final expectedHash = base64.decode(parts[1]);
    final actualHash = await _deriveBytes(password, salt);
    return _constantTimeEquals(actualHash, expectedHash);
  }

  Future<List<int>> _deriveBytes(String password, List<int> salt) async {
    final secretKey = await _algorithm.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    return secretKey.extractBytes();
  }

  List<int> _generateSalt() {
    final random = Random.secure();
    return List<int>.generate(_saltLengthInBytes, (_) => random.nextInt(256));
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}
