import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../config/security_config.dart';
import '../models/token_claims.dart';
import 'secrets_datasource.dart';
import 'token_datasource.dart';

class TokenDatasourceImpl implements TokenDatasource {
  TokenDatasourceImpl({required SecretsDatasource secretsDatasource})
      : _secretsDatasource = secretsDatasource;

  static const _jwtSecretKey = 'jwt_secret';

  final SecretsDatasource _secretsDatasource;

  @override
  Future<String> generateToken({
    required String subject,
    Map<String, dynamic> extraClaims = const {},
    Duration? expiresIn,
  }) async {
    final secret = await _secretsDatasource.getOrCreate(_jwtSecretKey);
    final jwt = JWT(Map<String, dynamic>.from(extraClaims), subject: subject);
    return jwt.sign(
      SecretKey(secret),
      expiresIn: expiresIn ?? SecurityConfig.tokenLifetime,
    );
  }

  @override
  Future<TokenClaims?> validateToken(String token) async {
    final secret = await _secretsDatasource.getOrCreate(_jwtSecretKey);
    try {
      final jwt = JWT.verify(token, SecretKey(secret));
      return TokenClaims(
        token: token,
        payload: Map<String, dynamic>.from(jwt.payload as Map),
      );
    } on JWTException {
      return null;
    }
  }
}
