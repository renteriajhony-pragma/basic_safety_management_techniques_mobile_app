class SubjectValidator {
  static const int minLength = 3;
  static const int maxLength = 32;
  static final RegExp allowedCharacters = RegExp(r'^[a-zA-Z0-9_-]+$');

  static bool isValid(String subject) =>
      subject.length >= minLength &&
      subject.length <= maxLength &&
      allowedCharacters.hasMatch(subject);
}
