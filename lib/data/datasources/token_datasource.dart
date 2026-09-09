import '../models/token_claims.dart';

abstract interface class TokenDatasource {
  /// When [expiresIn] is omitted, the implementation falls back to the
  /// configured token lifetime.
  Future<String> generateToken({
    required String subject,
    Duration? expiresIn,
  });

  Future<TokenClaims?> validateToken(String token);
}
