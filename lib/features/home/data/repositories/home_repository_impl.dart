import 'package:shartflix/core/error/exceptions.dart';
import 'package:shartflix/core/services/analytics_service.dart';
import 'package:shartflix/core/services/logger_service.dart';
import 'package:shartflix/features/home/data/datasources/home_remote_datasource.dart';
import 'package:shartflix/features/home/domain/entities/movie_list_entity.dart';
import 'package:shartflix/features/home/domain/repositories/home_repository.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDataSource;
  final LoggerService logger;
  final AnalyticsService analytics;

  const HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
    required this.analytics,
  });

  @override
  Future<MovieListEntity> getMovies(int page) async {
    try {
      final movieResponseModel = await remoteDataSource.getMovies(page);
      return movieResponseModel.toEntity();
    } on ServerException catch (e, stackTrace) {
      if (e.statusCode == null || e.statusCode! >= 500) {
        logger.recordError(
          exception: e,
          stackTrace: stackTrace,
          reason: 'HomeRepository: Film listesi çekilemedi',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'HomeRepository: Film listesi çekilirken beklenmedik hata',
        fatal: true,
      );
      rethrow;
    }
  }

  @override
  Future<MovieEntity> toggleFavorite(String movieId) async {
    try {
      final response = await remoteDataSource.toggleFavorite(movieId);
      await analytics.logCustomEvent(
        name: 'toggle_favorite',
        parameters: {
          'movie_id': movieId,
        },
      );
      return response.movie.toEntity();
    } on ServerException catch (e, stackTrace) {
      if (e.statusCode == null || e.statusCode! >= 500) {
        logger.recordError(
          exception: e,
          stackTrace: stackTrace,
          reason: 'HomeRepository: Favori değiştirilemedi (movieId: $movieId)',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      logger.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason:
            'HomeRepository: Favori değiştirilirken beklenmedik hata (movieId: $movieId)',
        fatal: true,
      );
      rethrow;
    }
  }
}
