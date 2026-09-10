import '../entities/user_profile.dart';

abstract interface class UserRepository {
  Future<void> register(UserProfile profile, String password);

  Future<bool> hasRegisteredUser();

  Future<bool> verifyCredentials(String usuario, String password);

  Future<UserProfile?> getProfile();
}
