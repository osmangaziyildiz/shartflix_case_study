import 'package:shartflix/features/home/data/datasources/home_remote_datasource.dart';
import 'package:shartflix/features/home/domain/entities/movie_list_entity.dart';
import 'package:shartflix/features/home/domain/repositories/home_repository.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MovieListEntity> getMovies(int page) async {
      final movieResponseModel = await remoteDataSource.getMovies(page);
      return movieResponseModel.toEntity();
  }

  @override
  Future<MovieEntity> toggleFavorite(String movieId) async {
      final response = await remoteDataSource.toggleFavorite(movieId);
      return response.movie.toEntity();
    
  }
}
