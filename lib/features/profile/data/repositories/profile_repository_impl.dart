import 'package:shartflix/core/error/exceptions.dart';
import 'package:shartflix/core/services/logger_service.dart';
import 'package:shartflix/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shartflix/features/profile/domain/entities/user_profile_entity.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';
import 'package:shartflix/features/profile/domain/repositories/profile_repository.dart';
import 'dart:io';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final LoggerService logger;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
  });

  @override
  Future<UserProfileEntity> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return model.toEntity();
    } on ServerException catch (e, stackTrace) {
      if (e.statusCode == null || e.statusCode! >= 500) {
        logger.recordError(
          exception: e,
          stackTrace: stackTrace,
          reason: 'ProfileRepository: Profil bilgisi alınamadı',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'ProfileRepository: Profil bilgisi alınırken beklenmedik hata',
        fatal: true,
      );
      rethrow;
    }
  }

  @override
  Future<UserProfileEntity> uploadPhoto(File file) async {
    try {
      final model = await remoteDataSource.uploadPhoto(file);
      return model.toEntity();
    } on ServerException catch (e, stackTrace) {
      if (e.statusCode == null || e.statusCode! >= 500) {
        logger.recordError(
          exception: e,
          stackTrace: stackTrace,
          reason: 'ProfileRepository: Fotoğraf yüklenemedi',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'ProfileRepository: Fotoğraf yüklenirken beklenmedik hata',
        fatal: true,
      );
      rethrow;
    }
  }

  @override
  Future<List<MovieEntity>> getFavoriteMovies() async {
    try {
      final models = await remoteDataSource.getFavoriteMovies();
      return models.map((model) => model.toEntity()).toList();
    } on ServerException catch (e, stackTrace) {
      if (e.statusCode == null || e.statusCode! >= 500) {
        logger.recordError(
          exception: e,
          stackTrace: stackTrace,
          reason: 'ProfileRepository: Favori filmler alınamadı',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason:
            'ProfileRepository: Favori filmler alınırken beklenmedik hata',
        fatal: true,
      );
      rethrow;
    }
  }
} 