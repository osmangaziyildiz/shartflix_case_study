import 'package:get_it/get_it.dart';
import 'package:shartflix/core/network/dio_client.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Network
  sl.registerSingleton<DioClient>(DioClient.instance);

  // Burada diğer servisleri de register edebilirsin:
  // sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  // sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl()));
} 