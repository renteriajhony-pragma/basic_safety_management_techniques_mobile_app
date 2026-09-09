import '../models/token_claims.dart';

abstract interface class TokenDatasource {
  /// When [expiresIn] is omitted, the implementation falls back to the
  /// token lifetime configured via environment variables.
  String generateToken({
    required String subject,
    Duration? expiresIn,
  });

  TokenClaims? validateToken(String token);
}
