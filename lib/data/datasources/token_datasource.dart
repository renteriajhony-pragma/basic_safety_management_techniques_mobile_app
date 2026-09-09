import '../models/token_claims.dart';

abstract interface class TokenDatasource {
  /// When [expiresIn] is omitted, the implementation falls back to the
  /// configured token lifetime. [extraClaims] are embedded in the signed
  /// payload alongside the standard claims (subject, issued-at, expiry).
  Future<String> generateToken({
    required String subject,
    Map<String, dynamic> extraClaims = const {},
    Duration? expiresIn,
  });

  Future<TokenClaims?> validateToken(String token);
}
