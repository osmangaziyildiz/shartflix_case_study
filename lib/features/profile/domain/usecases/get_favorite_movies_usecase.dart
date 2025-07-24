import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';
import 'package:shartflix/features/profile/domain/repositories/profile_repository.dart';

class GetFavoriteMoviesUseCase {
  final ProfileRepository repository;
  GetFavoriteMoviesUseCase({required this.repository});

  Future<List<MovieEntity>> call() async {
    return await repository.getFavoriteMovies();
  }
} 