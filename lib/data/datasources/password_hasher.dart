abstract interface class PasswordHasher {
  /// Returns a salted, irreversible hash of [password].
  Future<String> hash(String password);

  /// Recomputes the hash of [password] with the salt embedded in
  /// [encodedHash] and compares it, without ever reversing [encodedHash].
  Future<bool> verify(String password, String encodedHash);
}
