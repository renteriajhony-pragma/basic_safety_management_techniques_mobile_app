class SecurityConfig {
  /// Not a secret, so it can safely be a compile-time constant.
  static const Duration tokenLifetime = Duration(minutes: 2);
}
