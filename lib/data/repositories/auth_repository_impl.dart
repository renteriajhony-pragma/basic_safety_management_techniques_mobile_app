import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../mappers/auth_session_mapper.dart';
import '../services/key_value_storage.dart';
import '../services/token_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required TokenService tokenService,
    required KeyValueStorage storage,
    AuthSessionMapper mapper = const AuthSessionMapper(),
  })  : _tokenService = tokenService,
        _storage = storage,
        _mapper = mapper;

  static const _tokenStorageKey = 'auth_token';

  final TokenService _tokenService;
  final KeyValueStorage _storage;
  final AuthSessionMapper _mapper;

  @override
  Future<AuthSession> createSession(String subject) async {
    final token = _tokenService.generateToken(subject: subject);
    await _storage.save(_tokenStorageKey, token);
    return _sessionFromToken(token)!;
  }

  @override
  Future<AuthSession?> getSession() async {
    final token = await _storage.read(_tokenStorageKey);
    if (token == null) return null;
    return _sessionFromToken(token);
  }

  AuthSession? _sessionFromToken(String token) {
    final claims = _tokenService.validateToken(token);
    if (claims == null) return null;
    return _mapper.toEntity(claims);
  }
}
