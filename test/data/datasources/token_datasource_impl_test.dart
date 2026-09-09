import 'package:flutter_test/flutter_test.dart';
import 'package:security_app/data/datasources/token_datasource_impl.dart';

import '../../helpers/fake_secrets_datasource.dart';

void main() {
  late TokenDatasourceImpl tokenDatasource;

  setUp(() {
    tokenDatasource = TokenDatasourceImpl(
      secretsDatasource: FakeSecretsDatasource(),
    );
  });

  test('genera un JWT con el subject solicitado', () async {
    final token = await tokenDatasource.generateToken(subject: 'user-1');

    expect(token, isNotEmpty);
    expect(token.split('.'), hasLength(3));
  });

  test('valida un token recién generado', () async {
    final token = await tokenDatasource.generateToken(subject: 'user-1');

    final claims = await tokenDatasource.validateToken(token);

    expect(claims, isNotNull);
    expect(claims!.payload['sub'], 'user-1');
  });

  test('rechaza un token expirado', () async {
    final token = await tokenDatasource.generateToken(
      subject: 'user-1',
      expiresIn: const Duration(seconds: -1),
    );

    final claims = await tokenDatasource.validateToken(token);

    expect(claims, isNull);
  });

  test('rechaza un token manipulado', () async {
    final token = await tokenDatasource.generateToken(subject: 'user-1');
    final tampered = '${token.substring(0, token.length - 1)}x';

    final claims = await tokenDatasource.validateToken(tampered);

    expect(claims, isNull);
  });
}
