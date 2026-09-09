import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../config/security_config.dart';
import '../models/token_claims.dart';
import 'token_datasource.dart';

class TokenDatasourceImpl implements TokenDatasource {
  @override
  String generateToken({
    required String subject,
    Duration? expiresIn,
  }) {
    final jwt = JWT({}, subject: subject);
    return jwt.sign(
      SecretKey(SecurityConfig.secretKey),
      expiresIn: expiresIn ?? SecurityConfig.tokenLifetime,
    );
  }

  @override
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
