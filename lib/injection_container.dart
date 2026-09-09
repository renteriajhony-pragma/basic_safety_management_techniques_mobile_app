import 'package:get_it/get_it.dart';

import 'data/datasources/encryption_datasource.dart';
import 'data/datasources/encryption_datasource_impl.dart';
import 'data/datasources/secure_storage_datasource.dart';
import 'data/datasources/secure_storage_datasource_impl.dart';
import 'data/datasources/token_datasource.dart';
import 'data/datasources/token_datasource_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/clear_session_usecase.dart';
import 'domain/usecases/create_session_usecase.dart';
import 'domain/usecases/get_session_usecase.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<TokenDatasource>(TokenDatasourceImpl.new);
  sl.registerLazySingleton<EncryptionDatasource>(EncryptionDatasourceImpl.new);
  sl.registerLazySingleton<SecureStorageDatasource>(
    () => SecureStorageDatasourceImpl(encryptionDatasource: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      tokenDatasource: sl(),
      storageDatasource: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateSessionUseCase(sl()));
  sl.registerLazySingleton(() => GetSessionUseCase(sl()));
  sl.registerLazySingleton(() => ClearSessionUseCase(sl()));
}
