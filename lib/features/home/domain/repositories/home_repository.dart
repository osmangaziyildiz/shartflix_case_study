import 'package:shartflix/features/home/domain/entities/movie_list_entity.dart';

abstract class HomeRepository {
  Future<MovieListEntity> getMovies(int page);
} 