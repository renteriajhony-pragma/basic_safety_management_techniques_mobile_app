import '../models/token_claims.dart';

abstract interface class TokenDatasource {
  static const Duration defaultTokenLifetime = Duration(hours: 1);

  String generateToken({
    required String subject,
    Duration expiresIn = defaultTokenLifetime,
  });

  TokenClaims? validateToken(String token);
}
