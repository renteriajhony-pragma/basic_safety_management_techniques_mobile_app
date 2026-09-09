import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/secure_storage_datasource.dart';
import '../datasources/token_datasource.dart';
import '../mappers/auth_session_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required TokenDatasource tokenDatasource,
    required SecureStorageDatasource storageDatasource,
    AuthSessionMapper mapper = const AuthSessionMapper(),
  })  : _tokenDatasource = tokenDatasource,
        _storageDatasource = storageDatasource,
        _mapper = mapper;

  static const _tokenStorageKey = 'auth_token';

  final TokenDatasource _tokenDatasource;
  final SecureStorageDatasource _storageDatasource;
  final AuthSessionMapper _mapper;

  @override
  Future<AuthSession> createSession(String subject) async {
    final token = _tokenDatasource.generateToken(subject: subject);
    await _storageDatasource.save(_tokenStorageKey, token);
    return _sessionFromToken(token)!;
  }

  @override
  Future<AuthSession?> getSession() async {
    final token = await _storageDatasource.read(_tokenStorageKey);
    if (token == null) return null;
    return _sessionFromToken(token);
  }

  @override
  Future<void> clearSession() => _storageDatasource.delete(_tokenStorageKey);

  AuthSession? _sessionFromToken(String token) {
    final claims = _tokenDatasource.validateToken(token);
    if (claims == null) return null;
    return _mapper.toEntity(claims);
  }
}
