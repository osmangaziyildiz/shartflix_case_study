import 'package:shartflix/features/home/domain/repositories/home_repository.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

class ToggleFavoriteUsecase {
  final HomeRepository repository;

  const ToggleFavoriteUsecase(this.repository);

  Future<MovieEntity> call(String movieId) {
    return repository.toggleFavorite(movieId);
  }
} 