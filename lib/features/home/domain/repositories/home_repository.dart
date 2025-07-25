import 'package:shartflix/features/home/domain/entities/movie_list_entity.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';
 
abstract class HomeRepository {
  Future<MovieListEntity> getMovies(int page);
  Future<MovieEntity> toggleFavorite(String movieId);
} 