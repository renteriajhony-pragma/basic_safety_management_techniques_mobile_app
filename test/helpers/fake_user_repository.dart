import 'package:security_app/domain/entities/user_profile.dart';
import 'package:security_app/domain/repositories/user_repository.dart';

class FakeUserRepository implements UserRepository {
  UserProfile? storedProfile;
  String? storedPassword;

  @override
  Future<void> register(UserProfile profile, String password) async {
    storedProfile = profile;
    storedPassword = password;
  }

  @override
  Future<bool> hasRegisteredUser() async => storedProfile != null;

  @override
  Future<bool> verifyCredentials(String usuario, String password) async =>
      storedProfile?.usuario == usuario && storedPassword == password;

  @override
  Future<UserProfile?> getProfile() async => storedProfile;
}
