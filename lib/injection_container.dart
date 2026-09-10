import 'package:get_it/get_it.dart';

import 'data/datasources/encryption_datasource.dart';
import 'data/datasources/encryption_datasource_impl.dart';
import 'data/datasources/password_hasher.dart';
import 'data/datasources/password_hasher_impl.dart';
import 'data/datasources/secrets_datasource.dart';
import 'data/datasources/secrets_datasource_impl.dart';
import 'data/datasources/secure_storage_datasource.dart';
import 'data/datasources/secure_storage_datasource_impl.dart';
import 'data/datasources/token_datasource.dart';
import 'data/datasources/token_datasource_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/clear_session_usecase.dart';
import 'domain/usecases/get_session_usecase.dart';
import 'domain/usecases/get_user_profile_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/refresh_session_usecase.dart';
import 'domain/usecases/register_user_usecase.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<SecretsDatasource>(SecretsDatasourceImpl.new);
  sl.registerLazySingleton<TokenDatasource>(
    () => TokenDatasourceImpl(secretsDatasource: sl()),
  );
  sl.registerLazySingleton<EncryptionDatasource>(
    () => EncryptionDatasourceImpl(secretsDatasource: sl()),
  );
  sl.registerLazySingleton<SecureStorageDatasource>(
    () => SecureStorageDatasourceImpl(encryptionDatasource: sl()),
  );
  sl.registerLazySingleton<PasswordHasher>(PasswordHasherImpl.new);

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      tokenDatasource: sl(),
      storageDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      storageDatasource: sl(),
      passwordHasher: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetSessionUseCase(sl()));
  sl.registerLazySingleton(() => ClearSessionUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => RefreshSessionUseCase(sl()));
  sl.registerLazySingleton(
    () => LoginUseCase(userRepository: sl(), authRepository: sl()),
  );
}
