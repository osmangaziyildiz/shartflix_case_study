import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String cover;
  final String title;
  final String genre;
  final String plot;
  final bool isFavorite;

  const MovieEntity({
    required this.id,
    required this.cover,
    required this.title,
    required this.genre,
    required this.plot,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [id, cover, title, genre, plot, isFavorite];
} 