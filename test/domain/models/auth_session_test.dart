import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/domain/models/auth_session.dart';

void main() {
  test('es válida cuando la fecha de expiración está en el futuro', () {
    final session = AuthSession(
      token: 'token',
      subject: 'user-1',
      expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 1)),
    );

    expect(session.isValid, isTrue);
  });

  test('no es válida cuando la fecha de expiración ya pasó', () {
    final session = AuthSession(
      token: 'token',
      subject: 'user-1',
      expiresAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
    );

    expect(session.isValid, isFalse);
  });
}
