import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

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

  JWT? validateToken(String token) {
    try {
      return JWT.verify(token, SecretKey(SecurityConfig.secretKey));
    } on JWTException {
      return null;
    }
  }
}
