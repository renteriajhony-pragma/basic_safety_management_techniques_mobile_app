class PasswordValidator {
  static const int minLength = 8;
  static const int maxLength = 64;

  // Deliberately no character-set restriction: limiting which characters a
  // password may contain only reduces its entropy.
  static bool isValid(String password) =>
      password.length >= minLength && password.length <= maxLength;
}
