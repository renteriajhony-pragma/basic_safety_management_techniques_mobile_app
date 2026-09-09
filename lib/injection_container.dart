import 'package:get_it/get_it.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/services/key_value_storage.dart';
import 'data/services/secure_storage_service.dart';
import 'data/services/token_service.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/create_session_usecase.dart';
import 'domain/usecases/get_session_usecase.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<TokenService>(TokenService.new);
  sl.registerLazySingleton<KeyValueStorage>(SecureStorageService.new);

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      tokenService: sl(),
      storage: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateSessionUseCase(sl()));
  sl.registerLazySingleton(() => GetSessionUseCase(sl()));
}
