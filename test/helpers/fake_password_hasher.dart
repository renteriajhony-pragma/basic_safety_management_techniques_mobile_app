import 'package:security_app/data/datasources/password_hasher.dart';

class FakePasswordHasher implements PasswordHasher {
  @override
  Future<String> hash(String password) async => 'hashed:$password';

  @override
  Future<bool> verify(String password, String encodedHash) async =>
      encodedHash == 'hashed:$password';
}
