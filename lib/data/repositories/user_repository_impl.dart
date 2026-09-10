import 'dart:convert';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/password_hasher.dart';
import '../datasources/secure_storage_datasource.dart';
import '../mappers/user_profile_mapper.dart';
import '../models/user_record.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required SecureStorageDatasource storageDatasource,
    required PasswordHasher passwordHasher,
    UserProfileMapper mapper = const UserProfileMapper(),
  })  : _storageDatasource = storageDatasource,
        _passwordHasher = passwordHasher,
        _mapper = mapper;

  static const _profileStorageKey = 'user_profile';
  static const _passwordHashStorageKey = 'user_password_hash';

  final SecureStorageDatasource _storageDatasource;
  final PasswordHasher _passwordHasher;
  final UserProfileMapper _mapper;

  @override
  Future<void> register(UserProfile profile, String password) async {
    final record = _mapper.toRecord(profile);
    final passwordHash = await _passwordHasher.hash(password);
    await _storageDatasource.save(
      _profileStorageKey,
      jsonEncode(record.toJson()),
    );
    await _storageDatasource.save(_passwordHashStorageKey, passwordHash);
  }

  @override
  Future<bool> hasRegisteredUser() async =>
      await _storageDatasource.read(_profileStorageKey) != null;

  @override
  Future<bool> verifyCredentials(String usuario, String password) async {
    final profile = await getProfile();
    if (profile == null || profile.usuario != usuario) return false;

    final storedHash = await _storageDatasource.read(_passwordHashStorageKey);
    if (storedHash == null) return false;

    return _passwordHasher.verify(password, storedHash);
  }

  @override
  Future<UserProfile?> getProfile() async {
    final raw = await _storageDatasource.read(_profileStorageKey);
    if (raw == null) return null;

    final record = UserRecord.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return _mapper.toEntity(record);
  }
}
