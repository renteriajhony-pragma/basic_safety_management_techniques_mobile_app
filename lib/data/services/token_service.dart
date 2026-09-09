import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../models/token_claims.dart';
import 'security_config.dart';

class TokenService {
  static const Duration defaultTokenLifetime = Duration(hours: 1);

  String generateToken({
    required String subject,
    Duration expiresIn = defaultTokenLifetime,
  }) {
    final jwt = JWT({}, subject: subject);
    return jwt.sign(SecretKey(SecurityConfig.secretKey), expiresIn: expiresIn);
  }

  TokenClaims? validateToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(SecurityConfig.secretKey));
      return TokenClaims(
        token: token,
        payload: Map<String, dynamic>.from(jwt.payload as Map),
      );
    } on JWTException {
      return null;
    }
  }
}
