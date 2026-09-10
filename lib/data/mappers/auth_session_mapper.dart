import '../../domain/entities/auth_session.dart';
import '../models/token_claims.dart';

class AuthSessionMapper {
  const AuthSessionMapper();

  AuthSession toEntity(TokenClaims claims) {
    final expSeconds = claims.payload['exp'] as num;

    return AuthSession(
      token: claims.token,
      subject: claims.payload['sub'] as String? ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (expSeconds * 1000).toInt(),
        isUtc: true,
      ),
      givenName: claims.payload['given_name'] as String?,
      familyName: claims.payload['family_name'] as String?,
    );
  }
}
