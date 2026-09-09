import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/services/token_service.dart';

void main() {
  late TokenService tokenService;

  setUp(() {
    tokenService = TokenService();
  });

  test('genera un JWT con el subject solicitado', () {
    final token = tokenService.generateToken(subject: 'user-1');

    expect(token, isNotEmpty);
    expect(token.split('.'), hasLength(3));
  });

  test('valida un token recién generado', () {
    final token = tokenService.generateToken(subject: 'user-1');

    final claims = tokenService.validateToken(token);

    expect(claims, isNotNull);
    expect(claims!.payload['sub'], 'user-1');
  });

  test('rechaza un token expirado', () {
    final token = tokenService.generateToken(
      subject: 'user-1',
      expiresIn: const Duration(seconds: -1),
    );

    final claims = tokenService.validateToken(token);

    expect(claims, isNull);
  });

  test('rechaza un token manipulado', () {
    final token = tokenService.generateToken(subject: 'user-1');
    final tampered = '${token.substring(0, token.length - 1)}x';

    final claims = tokenService.validateToken(tampered);

    expect(claims, isNull);
  });
}
