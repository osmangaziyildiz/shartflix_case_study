import 'package:shartflix/core/error/exceptions.dart';
import 'package:shartflix/core/services/analytics_service.dart';
import 'package:shartflix/core/services/logger_service.dart';
import 'package:shartflix/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shartflix/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shartflix/features/auth/data/models/login_request_model.dart';
import 'package:shartflix/features/auth/data/models/register_request_model.dart';
import 'package:shartflix/features/auth/domain/entities/user_entity.dart';
import 'package:shartflix/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final LoggerService logger;
  final AnalyticsService analytics;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.logger,
    required this.analytics,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequestModel(
        email: email,
        password: password,
      );
      final response = await remoteDataSource.login(request);
      await localDataSource.saveToken(response.data.token);
      await logger.setUserIdentifier(email);
      await analytics.logLogin(loginMethod: 'email'); // Analytics olayı
      await analytics.setUserId(id: email); // Analytics için User ID ayarla
      return response.toEntity();
    } on ServerException catch (e, stackTrace) {
      if (e.statusCode == null || e.statusCode! >= 500) {
        logger.recordError(
          exception: e,
          stackTrace: stackTrace,
          reason: 'AuthRepository: Giriş sırasında sunucu/ağ hatası',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'AuthRepository: Giriş sırasında beklenmedik bir hata oluştu',
        fatal: true,
      );
      rethrow;
    }
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final request = RegisterRequestModel(
        email: email,
        name: name,
        password: password,
      );
      final response = await remoteDataSource.register(request);
      await localDataSource.saveToken(response.data.token);

      await logger.setUserIdentifier(email);
      await analytics.logSignUp(signUpMethod: 'email'); // Analytics olayı
      await analytics.setUserId(id: email); // Analytics için User ID ayarla
      return response.toEntity();
    } on ServerException catch (e, stackTrace) {
      if (e.statusCode == null || e.statusCode! >= 500) {
        logger.recordError(
          exception: e,
          stackTrace: stackTrace,
          reason: 'AuthRepository: Kayıt sırasında sunucu/ağ hatası',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'AuthRepository: Kayıt sırasında beklenmedik bir hata oluştu',
        fatal: true,
      );
      rethrow;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await localDataSource.saveToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteToken();
    await logger.setUserIdentifier(''); // Crashlytics için kimliği temizle
    await analytics.setUserId(id: null); // Analytics için kimliği temizle
  }
} 