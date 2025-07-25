import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shartflix/core/network/dio_client.dart';
import 'package:shartflix/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shartflix/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shartflix/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shartflix/features/auth/domain/repositories/auth_repository.dart';
import 'package:shartflix/features/auth/domain/usecases/login_usecase.dart';
import 'package:shartflix/features/auth/domain/usecases/register_usecase.dart';
import 'package:shartflix/features/auth/presentation/viewmodels/auth_view_model.dart';
// Profile feature imports
import 'package:shartflix/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shartflix/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:shartflix/features/profile/domain/repositories/profile_repository.dart';
import 'package:shartflix/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/upload_photo_usecase.dart';
import 'package:shartflix/features/profile/domain/usecases/get_favorite_movies_usecase.dart';
import 'package:shartflix/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:shartflix/features/home/data/datasources/home_remote_datasource.dart';
import 'package:shartflix/features/home/data/repositories/home_repository_impl.dart';
import 'package:shartflix/features/home/domain/repositories/home_repository.dart';
import 'package:shartflix/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:shartflix/features/home/domain/usecases/toggle_favorite_usecase.dart';
import 'package:shartflix/features/home/presentation/viewmodels/home_view_model.dart';

import 'logger_service.dart';
import 'analytics_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  sl.registerSingleton<DioClient>(DioClient.instance);
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);
  sl.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);
  sl.registerSingleton<LoggerService>(LoggerServiceImpl(sl<FirebaseCrashlytics>()));
  sl.registerSingleton<AnalyticsService>(
    AnalyticsServiceImpl(sl<FirebaseAnalytics>()),
  );

  // Bu stream sadece favori filmler veya profil bilgileri değiştiğinde rebuild oluyor.
  // Bu sayede kullanıcı her "Profil" sekmesine geçtiğinde gereksiz yere API isteği yapılmıyor.
  sl.registerLazySingleton<StreamController<String>>(
    () => StreamController<String>.broadcast(),
  );

  // Auth feature DI
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      logger: sl<LoggerService>(),
      analytics: sl<AnalyticsService>(),
    ),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
    ),
  );

  // Home feature DI
  sl.registerFactory<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl<HomeRemoteDatasource>(),
      logger: sl<LoggerService>(),
      analytics: sl<AnalyticsService>(),
    ),
  );
  sl.registerFactory<GetMoviesUsecase>(
    () => GetMoviesUsecase(sl<HomeRepository>()),
  );
  sl.registerFactory<ToggleFavoriteUsecase>(
    () => ToggleFavoriteUsecase(sl<HomeRepository>()),
  );
  sl.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      getMoviesUsecase: sl(),
      toggleFavoriteUsecase: sl(),
    ),
  );

  // Profile feature DI
  sl.registerFactory<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
      logger: sl<LoggerService>(),
    ),
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
