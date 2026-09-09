import '../../domain/models/auth_session.dart';
import '../services/key_value_storage.dart';
import '../services/token_service.dart';

class AuthRepository {
  AuthRepository({
    required TokenService tokenService,
    required KeyValueStorage storage,
  })  : _tokenService = tokenService,
        _storage = storage;

  static const _tokenStorageKey = 'auth_token';

  final TokenService _tokenService;
  final KeyValueStorage _storage;

  Future<AuthSession> createSession(String subject) async {
    final token = _tokenService.generateToken(subject: subject);
    await _storage.save(_tokenStorageKey, token);
    return _sessionFromToken(token)!;
  }

  Future<AuthSession?> getSession() async {
    final token = await _storage.read(_tokenStorageKey);
    if (token == null) return null;
    return _sessionFromToken(token);
  }

  AuthSession? _sessionFromToken(String token) {
    final jwt = _tokenService.validateToken(token);
    if (jwt == null) return null;

    final claims = jwt.payload as Map<String, dynamic>;
    final expSeconds = claims['exp'] as num;

    return AuthSession(
      token: token,
      subject: jwt.subject ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (expSeconds * 1000).toInt(),
        isUtc: true,
      ),
    );
  }
}
