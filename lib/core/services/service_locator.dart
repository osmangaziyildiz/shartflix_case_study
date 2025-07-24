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
// Profile feature imports
import 'package:shartflix/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shartflix/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:shartflix/features/profile/domain/repositories/profile_repository.dart';
import 'package:shartflix/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/upload_photo_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/get_favorite_movies_usecase.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:shartflix/features/home/data/datasources/home_remote_datasource.dart';
import 'package:shartflix/features/home/data/repositories/home_repository_impl.dart';
import 'package:shartflix/features/home/domain/repositories/home_repository.dart';
import 'package:shartflix/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerSingleton<DioClient>(DioClient.instance);
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // Auth feature DI
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

  // Home feature DI
  sl.registerFactory<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl<HomeRemoteDatasource>()),
  );
  sl.registerFactory<GetMoviesUsecase>(
    () => GetMoviesUsecase(sl<HomeRepository>()),
  );
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(getMoviesUsecase: sl()),
  );

  // Profile feature DI
  sl.registerFactory<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );
  sl.registerFactory<GetProfileUseCase>(
    () => GetProfileUseCase(repository: sl<ProfileRepository>()),
  );
  sl.registerFactory<UploadPhotoUseCase>(
    () => UploadPhotoUseCase(repository: sl<ProfileRepository>()),
  );
  sl.registerFactory<GetFavoriteMoviesUseCase>(
    () => GetFavoriteMoviesUseCase(repository: sl<ProfileRepository>()),
  );
  sl.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(
      getProfileUseCase: sl<GetProfileUseCase>(),
      uploadPhotoUseCase: sl<UploadPhotoUseCase>(),
      getFavoriteMoviesUseCase: sl<GetFavoriteMoviesUseCase>(),
    ),
  );
}
