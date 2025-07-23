import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shartflix/core/network/dio_client.dart';
import 'package:shartflix/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shartflix/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shartflix/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shartflix/features/auth/domain/repositories/auth_repository.dart';
import 'package:shartflix/features/auth/domain/usecases/login_usecase.dart';
import 'package:shartflix/features/auth/domain/usecases/register_usecase.dart';
import 'package:shartflix/features/auth/presentation/viewmodels/auth_viewmodel.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  
  sl.registerSingleton<DioClient>(DioClient.instance);
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  sl.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  
  sl.registerFactory<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl<FlutterSecureStorage>()),
  );

  sl.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  sl.registerFactory<LoginUseCase>(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerFactory<RegisterUseCase>(
    () => RegisterUseCase(repository: sl<AuthRepository>()),
  );

  sl.registerFactory<AuthViewmodel>(
    () => AuthViewmodel(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
    ),
  );
}
