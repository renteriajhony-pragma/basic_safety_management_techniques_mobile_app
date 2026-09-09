import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/token_datasource_impl.dart';

import '../../helpers/test_env.dart';

void main() {
  late TokenDatasourceImpl tokenDatasource;

  setUpAll(loadTestEnv);

  setUp(() {
    tokenDatasource = TokenDatasourceImpl();
  });

  test('genera un JWT con el subject solicitado', () {
    final token = tokenDatasource.generateToken(subject: 'user-1');

    expect(token, isNotEmpty);
    expect(token.split('.'), hasLength(3));
  });

  test('valida un token recién generado', () {
    final token = tokenDatasource.generateToken(subject: 'user-1');

    final claims = tokenDatasource.validateToken(token);

    expect(claims, isNotNull);
    expect(claims!.payload['sub'], 'user-1');
  });

  test('rechaza un token expirado', () {
    final token = tokenDatasource.generateToken(
      subject: 'user-1',
      expiresIn: const Duration(seconds: -1),
    );

    final claims = tokenDatasource.validateToken(token);

    expect(claims, isNull);
  });

  test('rechaza un token manipulado', () {
    final token = tokenDatasource.generateToken(subject: 'user-1');
    final tampered = '${token.substring(0, token.length - 1)}x';

    final claims = tokenDatasource.validateToken(tampered);

    expect(claims, isNull);
  });
}
