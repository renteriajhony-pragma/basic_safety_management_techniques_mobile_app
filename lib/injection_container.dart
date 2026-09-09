import 'package:get_it/get_it.dart';

import 'data/datasources/secure_storage_datasource.dart';
import 'data/datasources/secure_storage_datasource_impl.dart';
import 'data/datasources/token_datasource.dart';
import 'data/datasources/token_datasource_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/create_session_usecase.dart';
import 'domain/usecases/get_session_usecase.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<TokenDatasource>(TokenDatasourceImpl.new);
  sl.registerLazySingleton<SecureStorageDatasource>(
    SecureStorageDatasourceImpl.new,
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      tokenDatasource: sl(),
      storageDatasource: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateSessionUseCase(sl()));
  sl.registerLazySingleton(() => GetSessionUseCase(sl()));
}
