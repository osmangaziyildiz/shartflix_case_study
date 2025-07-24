import 'package:equatable/equatable.dart';
import 'package:shartflix/features/home/domain/entities/pagination_entity.dart';
import 'package:shartflix/features/profile/domain/entities/movie_entity.dart';

class MovieListEntity extends Equatable {
  final List<MovieEntity> movies;
  final PaginationEntity pagination;

  const MovieListEntity({
    required this.movies,
    required this.pagination,
  });

  @override
  List<Object?> get props => [movies, pagination];
} 