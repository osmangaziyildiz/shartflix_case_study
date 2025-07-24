import 'package:shartflix/features/profile/data/models/movie_model.dart';

class ToggleFavoriteResponseModel {
  final MovieModel movie;
  final String action;

  const ToggleFavoriteResponseModel({
    required this.movie,
    required this.action,
  });

  factory ToggleFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return ToggleFavoriteResponseModel(
      movie: MovieModel.fromJson(json['movie']),
      action: json['action'] ?? '',
    );
  }
} 