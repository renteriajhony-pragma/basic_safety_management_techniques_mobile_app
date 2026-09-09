import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/mappers/auth_session_mapper.dart';
import 'package:security_app/data/models/token_claims.dart';

void main() {
  test('convierte los claims del token en una entidad AuthSession', () {
    const mapper = AuthSessionMapper();
    final claims = TokenClaims(
      token: 'token-123',
      payload: {'sub': 'user-1', 'exp': 2000000000},
    );

    final session = mapper.toEntity(claims);

    expect(session.token, 'token-123');
    expect(session.subject, 'user-1');
    expect(session.expiresAt, DateTime.fromMillisecondsSinceEpoch(2000000000000, isUtc: true));
  });
}
