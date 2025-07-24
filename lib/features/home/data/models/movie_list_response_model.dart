import 'package:shartflix/features/home/data/models/pagination_model.dart';
import 'package:shartflix/features/home/domain/entities/movie_list_entity.dart';
import 'package:shartflix/features/profile/data/models/movie_model.dart';

class MovieListResponseModel {
  final List<MovieModel> movies;
  final PaginationModel pagination;

  const MovieListResponseModel({
    required this.movies,
    required this.pagination,
  });

  factory MovieListResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieListResponseModel(
      movies: (json['movies'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  MovieListEntity toEntity() {
    return MovieListEntity(
      movies: movies.map((movie) => movie.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
} 