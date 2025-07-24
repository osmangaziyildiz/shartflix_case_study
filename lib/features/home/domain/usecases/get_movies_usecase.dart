import 'package:shartflix/features/home/domain/entities/movie_list_entity.dart';
import 'package:shartflix/features/home/domain/repositories/home_repository.dart';

class GetMoviesUsecase {
  final HomeRepository repository;

  GetMoviesUsecase(this.repository);

  Future<MovieListEntity> call(int page) {
    return repository.getMovies(page);
  }
} 